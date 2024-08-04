#!/bin/bash
set -e
rm -f /rails/tmp/pids/server.pid
bundle exec rake db:{drop,create,migrate,seed}
exec "$@"
