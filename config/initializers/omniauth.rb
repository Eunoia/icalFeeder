OmniAuth.config.logger = Rails.logger 

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :eventbrite, ENV['EVENTBRITE_CLIENT_ID'], ENV['EVENTBRITE_CLIENT_SECRET'], :strategy_class => OmniAuth::Strategies::Eventbrite
end