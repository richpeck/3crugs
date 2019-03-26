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

    # => ActiveJob Throttle
    # => Allows us to manage the underlying rate limiting of API requests
    ActiveJob::TrafficControl.client = Redis.new( host: Rails.application.credentials.dig(Rails.env.to_sym, :redis, :host), port: Rails.application.credentials.dig(Rails.env.to_sym, :redis, :port), password: Rails.application.credentials.dig(Rails.env.to_sym, :redis, :pass))

    # => Redis
    # => Hosted at RedisLabs
    # => Both settings required to get it working
    Sidekiq.configure_client do |config|
      config.redis = { url: "redis://#{Rails.application.credentials.dig(Rails.env.to_sym, :redis, :host)}:#{Rails.application.credentials.dig(Rails.env.to_sym, :redis, :port)}", password:  Rails.application.credentials.dig(Rails.env.to_sym, :redis, :pass) }
    end

    Sidekiq.configure_server do |config|
      config.redis = { url: "redis://#{Rails.application.credentials.dig(Rails.env.to_sym, :redis, :host)}:#{Rails.application.credentials.dig(Rails.env.to_sym, :redis, :port)}", password:  Rails.application.credentials.dig(Rails.env.to_sym, :redis, :pass) }
    end

  end
end

###############################################################
###############################################################
