FROM ruby:3.2.2

WORKDIR /init
COPY Gemfile* .
RUN apt update && apt install -y vim \
    && gem install bundler:2.4.21 jekyll:3.9.3 && bundle install

EXPOSE 4000 35729
