require "sidekiq"

KEY = "CONTEXT"

class ClientMiddleware
  def call(_, job, _, _)
    add_context_to(job)
    yield
  end

  private
  def add_context_to(job)
    store = { "Job-Context-Example-A" => "this is a metadata",
      "Job-Context-Example-B" => "this is another metadata" }
    job[KEY] = store
  rescue => e
    # Log/notify error as we do not want to fail the job in this case
    puts e
  end
end

class ServerMiddleware
  def call(_, job, _)
    get_context_from(job)
    yield
  end

  private
  def get_context_from(job)
    if job[KEY]
      job[KEY].each do |k, v|
        puts k,v
      end
    end
  rescue => e
    # Log/notify error as we do not want to fail the job in this case
    puts e
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis:127.0.0.1:6379' }
  config.client_middleware do |chain|
    chain.add ClientMiddleware
  end
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis:127.0.0.1:6379' }
  config.server_middleware do |chain|
    chain.add ServerMiddleware
  end
end

class MyWorker
  include Sidekiq::Worker

  def perform(lifting, *args)
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