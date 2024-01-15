FROM ruby:3.2.2-slim

WORKDIR /work

RUN apt-get update && apt-get install make build-essential -y

RUN gem install puma sinatra json

USER 1000

COPY ./ /work

CMD ["puma", "config.ru", "-C", "puma.rb"]
