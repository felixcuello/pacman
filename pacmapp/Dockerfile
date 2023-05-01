FROM ruby:3.2.2-bullseye

COPY . /app

WORKDIR /app

RUN bundle install

CMD ruby run.rb input.txt      # Runs the game with the input.txt sample
