module ApplicationHelper

  ## Sidekiq Total ##
  def sidekiq_total
    scheduled = Sidekiq::ScheduledSet.new
    queued    = Sidekiq::Queue.new("sync")
    scheduled.size + queued.size
  end

end
