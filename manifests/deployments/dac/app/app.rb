require 'sinatra'
require 'json'

ALLOWED = (ENV.fetch('ALLOWED') {false}).to_s.downcase == "true"
ADDITIONAL_CRDS = (ENV.fetch('ADDITIONAL_CRDS') {""}).to_s.split(",")

class Application < Sinatra::Base
  get '/health' do
    'up and running'
  end

  post '/validate' do
    req = JSON.parse(request.body.read)

    content_type :json

    # bypass from env
    if ALLOWED
      return {
        "apiVersion": req["apiVersion"],
        "kind": "AdmissionReview",
        "response": {
          "uid": req["request"]["uid"],
          "allowed": true
        }
      }.to_json
    end

    # check if resources name includes
    flux_crds = [
      "buckets.source.toolkit.fluxcd.io",
      "gitrepositories.source.toolkit.fluxcd.io",
      "helmcharts.source.toolkit.fluxcd.io",
      "helmreleases.helm.toolkit.fluxcd.io",
      "helmrepositories.source.toolkit.fluxcd.io",
      "kustomizations.kustomize.toolkit.fluxcd.io",
      "ocirepositories.source.toolkit.fluxcd.io",
      "providers.notification.toolkit.fluxcd.io",
      "receivers.notification.toolkit.fluxcd.io",
      "alerts.notification.toolkit.fluxcd.io",
    ]
    crds = flux_crds + ADDITIONAL_CRDS
    if !crds.include?(req["request"]["name"])
      return {
        "apiVersion": req["apiVersion"],
        "kind": "AdmissionReview",
        "response": {
          "uid": req["request"]["uid"],
          "allowed": true
        }
      }.to_json
    end

    {
      "apiVersion": req["apiVersion"],
      "kind": "AdmissionReview",
      "response": {
        "uid": req["request"]["uid"],
        "allowed": false,
        "status": {
          "code": 403,
          "message": "Your action forbidden. PLease Contact Hosting Team. #dac-update-crds-denied."
        }
      }
    }.to_json
  end
end
