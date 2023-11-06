FROM ruby:3.2.2

RUN apt update && apt install -y vim \
    && gem install bundler:2.4.21 jekyll:3.9.3

WORKDIR /build

COPY Gemfile* .

RUN bundle install

COPY . .

EXPOSE 4000 35729

ENTRYPOINT []

CMD ["./jekyll-serve.sh"]