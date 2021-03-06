###############################################
###############################################
##       _____            _                  ##
##      | ___ \          | |                 ##
##      | |_/ /___  _   _| |_ ___  ___       ##
##      |    // _ \| | | | __/ _ \/ __|      ##
##      | |\ \ (_) | |_| | ||  __/\__ \      ##
##      \_| \_\___/ \__,_|\__\___||___/      ##
##                                           ##
###############################################
###############################################

## Routes ##
## More in the FL Gem ##
Rails.application.routes.draw do

  # => Sidekiq
  # => Allows us to monitor Sidekiq queues etc
  authenticate :user do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

end

###############################################
###############################################
