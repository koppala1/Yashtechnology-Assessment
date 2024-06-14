class WebhookService
  def self.notify_endpoints(data)
    endpoints = Rails.configuration.webhook_endpoints || []
    endpoints.each do |endpoint|
    end
  end
end
