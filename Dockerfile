FROM ruby:3.2.2

RUN gem install bundler -v 2.4.21 && gem install jekyll -v 3.9.3

WORKDIR /init
COPY Gemfile* .
RUN bundle install

EXPOSE 4000 35729