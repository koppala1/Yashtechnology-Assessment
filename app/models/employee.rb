class Employee < ApplicationRecord

after_save :notify_webhooks

validates :employee_name, presence:true
validates :employee_id, numericality:true

private

def notify_webhooks
  WebhookService.notify_endpoints(self)
end

end
