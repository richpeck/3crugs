class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  ActiveJob::TrafficControl.client = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: 'redis-10653.c77.eu-west-1-1.ec2.cloud.redislabs.com', port: 10653, password: 'AX6YS7Ma4aJHm46AXooBLB63Lozw6doP') }
end
