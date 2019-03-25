require_relative 'boot'

require 'rails/all'

###############################################################
###############################################################
##       ___              _ _           _   _                ##
##      / _ \            | (_)         | | (_)               ##
##     / /_\ \_ __  _ __ | |_  ___ __ _| |_ _  ___  _ __     ##
##     |  _  | '_ \| '_ \| | |/ __/ _` | __| |/ _ \| '_ \    ##
##     | | | | |_) | |_) | | | (_| (_| | |_| | (_) | | | |   ##
##     \_| |_/ .__/| .__/|_|_|\___\__,_|\__|_|\___/|_| |_|   ##
##           | |   | |                                       ##
##           |_|   |_|                                       ##
###############################################################
###############################################################

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

###############################################################
###############################################################

module Rugs
  class Application < Rails::Application

    # => Rails 6.0
    # => Allows us to use all the defaults etc
    config.load_defaults 6.0

    # => ActiveJob
    # => Allows us to manage the queue for the "sync all" method
    config.active_job.queue_adapter = :sidekiq

    # => Redis
    # => Hosted at RedisLabs
    # => Both settings required to get it working
    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://redis-10653.c77.eu-west-1-1.ec2.cloud.redislabs.com:10653', password:  'AX6YS7Ma4aJHm46AXooBLB63Lozw6doP' }
    end

    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://redis-10653.c77.eu-west-1-1.ec2.cloud.redislabs.com:10653', password:  'AX6YS7Ma4aJHm46AXooBLB63Lozw6doP' }
    end

  end
end

###############################################################
###############################################################
