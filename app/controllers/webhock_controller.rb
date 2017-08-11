
class  WebhockController< ApplicationController
  protect_from_forgery except: :create
  def create
    Payjp.api_key = 'sk_test_3c5311aec4f5a022738b1f03'
    event = Payjp::Event.retrieve(params[:id])

    case event.type
      when 'subscription.updated'
        subscription = event.data
        user = User.find_by(subscription_id: subscription.id)
        user.update_subscription(subscription)
      when 'subscription.created'
        subscription = event.data
        user = User.find_by(subscription_id: subscription.id)
        user.test
      when 'subscription.deleted'
        subscription = event.data
        user = User.find_by(subscription_id: subscription.id)
        user.test
    end
    head :ok
  end
end