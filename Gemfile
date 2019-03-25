########################################
########################################

# => Sources
source 'https://rubygems.org'
source 'https://rails-assets.org' # => (Heroku) https://github.com/tenex/rails-assets/issues/325

########################################
########################################

# => Ruby
# => https://github.com/cantino/huginn/blob/master/Gemfile#L4
ruby [RUBY_VERSION, '2.6.1'].min

# => Rails
gem 'rails', github: 'rails/rails' #'~> 6.0.0.beta3'

# => Server
# => Default dev development for Rails 5 but still needs the gem....
# => https://richonrails.com/articles/the-rails-5-0-default-files
gem 'puma', groups: [:development, :staging] # => Production will use phusion with nginx

# => FL
# => Used for framework etc
gem 'fl', path: 'vendor/gems/fl'

# => DB
# => https://github.com/rrrene/projestimate/blob/master/Gemfile#L11
gem 'sqlite3', '1.3.13', group: :development
gem 'pg',                groups: [:staging, :production]

########################################
########################################

# Platform Specific
# http://bundler.io/v1.3/man/gemfile.5.html#PLATFORMS-platforms-

# => Win
gem 'tzinfo-data' if Gem.win_platform? # => TZInfo For Windows (Rails 6)

# => Not Windows
unless Gem.win_platform?
  gem 'execjs'       		# => http://stackoverflow.com/a/6283074/1143732
  gem 'mini_racer' 		  # => http://stackoverflow.com/a/6283074/1143732
end

########################################
########################################

####################
#     Frontend     #
####################

## HAML & SASS ##
gem 'sass-rails' # => Supercedes sass-rails // https://github.com/rails/sass-rails/pull/424
gem 'uglifier', '~> 3.0'
gem 'haml', '~> 5.0', '>= 5.0.3'

## JS ##
gem 'coffee-rails', '~> 4.2', '>= 4.2.1'
gem 'jquery-rails'
gem 'turbolinks', '~> 5.0'
gem 'jbuilder', '~> 2.0'

########################################
########################################

####################
#     Backend      #
####################

## General ##
## Used to provide general backend support for Rails apps ##
gem 'bootsnap', '~> 1.3', '>= 1.3.2', require: false  # => Boot caching (introduced in 5.2.x)
gem 'rubyzip', '~> 1.2', '>= 1.2.2'                   # => Used to unpack the CSV (why they've uploaded it as a zip is beyond me)
gem 'friendly_id', github: 'norman/friendly_id'       # => Fixes for Rails 6.0.0.beta3
gem 'activerecord-import', '~> 1.0', '>= 1.0.1'       # => Whilst upsert_all in beta // https://github.com/zdennis/activerecord-import
gem 'savon', '~> 2.12'                                # => Wrapper for SOAP API's (required for EKM)

## Queues ##
## This allows us to use ActiveJob to handle the "sync all" feature ##
gem 'sidekiq', '~> 5.2', '>= 5.2.5'         # => Sidekiq to manage the processing of jobs (held in Redis etc)
gem 'redis', '~> 4.1'                       # => Redis (stores ActiveQueue jobs)
gem 'activejob-traffic_control', '~> 0.1.3' # => Allows us to throttle the ActiveJob queue

## Active Admin ##
## Because of changes to Rails 6.0.0.beta3, need to keep these here for now ##
## When Rails 6.0 is released, I'm sure we can remove them ##
gem 'activeadmin', github: 'activeadmin/activeadmin'                 # => Master branch is Rails compatible
gem 'inherited_resources', github: 'activeadmin/inherited_resources' # => Required for Rails 6.0.0.beta3 compatibility

########################################
########################################
