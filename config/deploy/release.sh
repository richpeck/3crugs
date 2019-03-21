# bin/sh
# https://stackoverflow.com/a/32717779/1143732
# find . -name '*.sh' | xargs git update-index --chmod=+x

echo "Migrating...";
rails db:migrate;

echo "Seeding...";
rails db:seed;

echo "Clobbering...";
rake assets:clobber;

echo "Clearing Cache...";
rake tmp:clear;

echo "Precompiling...";
rake assets:precompile;
