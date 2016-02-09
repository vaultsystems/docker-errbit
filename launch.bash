#!/bin/bash
if [ -z "$SECRET_TOKEN" -a ! -f "config/initializers/__secret_token.rb" ]; then
  echo "Errbit::Application.config.secret_token = '$(bundle exec rake secret)'" > config/initializers/__secret_token.rb
fi
if [ "$1" == "web" ]; then
  rm tmp/pids/server.pid
  bundle exec rails server
elif [ "$1" == "seed" ]; then
  bundle exec rake errbit:bootstrap
elif [ "$1" == "upgrade" ]; then
  rake db:migrate
  rake db:mongoid:remove_undefined_indexes
  rake db:mongoid:create_indexes
  rake assets:precompile
else
  bundle exec "$@"
fi
