require "sidekiq"

class ServerMiddleware
  # This block runs before the job execution
  def call(worker, job_hash, queue)
    yield
  end
  # And, this block runs after the job execution
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis:127.0.0.1:6379' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis:127.0.0.1:6379' }
  config.server_middleware do |chain|
    chain.add ServerMiddleware
  end
end

class MyWorker
  include Sidekiq::Worker

  def perform(lifting)
    case lifting
    when "heavy"
      sleep 10 
      puts "did a heavy job"
    when "middle"
      sleep 5
      puts "did a middle job"
    else
      sleep 1
      puts "did a light job"
    end
  end
end