# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :facebook, '666677436743047', '7ddf922437f399b7bee2fd2f3a04c841'
#   provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
#   provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'  
# end

OmniAuth.config.logger = Rails.logger