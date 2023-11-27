FROM ruby:3.2

WORKDIR /work

RUN gem install puma sinatra json

USER 1000

COPY ./ /work

CMD ["puma", "config.ru", "-C", "puma.rb"]
