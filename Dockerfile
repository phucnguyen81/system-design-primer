FROM ruby:3.2.2

ARG TIMEZONE

USER root

RUN apt update && apt install -y vim \
    && gem install bundler:2.4.21 jekyll:3.9.3 \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 4000 35729

ENTRYPOINT []

CMD []
