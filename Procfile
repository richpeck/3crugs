# Release
# Uses bin/sh (separate commands with semi-colon)
release: ./config/deploy/release.sh

# Puma
# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#gemfile
web: bundle exec puma -C ./config/deploy/puma.rb
