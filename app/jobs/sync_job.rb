############################################################
############################################################
##                 _____                                  ##
##                /  ___|                                 ##
##                \ `--. _   _ _ __   ___                 ##
##                 `--. \ | | | '_ \ / __|                ##
##                /\__/ / |_| | | | | (__                 ##
##                \____/ \__, |_| |_|\___|                ##
##                        __/ |                           ##
##                        |___/                           ##
##                                                        ##
############################################################
############################################################

## Sync All ##
## Because of rate limiting, we need to queue the jobs ##
## This needs to be handled with Sidekik or Redis ##
class SyncJob < ActiveJob::Base
  queue_as :sync
  throttle threshold: 2, period: 5.seconds # => ActiveJobThrottle

  ## Too Many Requests ##
  ## Rescues the update and resubmits to the end of the queue ##
  rescue_from(StandardError) do
    retry_job queue: :low_priority
  end

  ## Perform Queue ##
  ## This allows us to send ID's from Resque/Sidekik and process them sequentially ##
  def perform(product_id)
    product = Product.find product_id
    #sync    = Meta::Sync.find_by ref 
    product.sync!
  end

end

############################################################
############################################################
