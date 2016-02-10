if Rails.env.production?
  if ENV["REDISCLOUD_URL"]
    $redis = Resque.redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
  end
end