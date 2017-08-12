class User < ApplicationRecord
  require 'payjp'
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:     auth.extra.raw_info.name,
                         provider: auth.provider,
                         uid:      auth.uid,
                         email:    auth.info.email,
                         password: Devise.friendly_token[0,20]
      )
    end
    user
  end

  def making_customer(current_user,token)
    Payjp.api_key = 'sk_test_3c5311aec4f5a022738b1f03'
    customer=Payjp::Customer.create(
        email:current_user.email,
        description: 'test',
        card:token
    )
    update(customer_id:customer.id)
  end

  def customer_id_check(current_user)
    begin
      Payjp.api_key = 'sk_test_3c5311aec4f5a022738b1f03'
      Payjp::Customer.retrieve("#{current_user.customer_id}")
    rescue =>e
      update(customer_id:nil,subscription_id:nil,expires_at:nil)
    end
  end

  def subscription(current_user)
    Payjp.api_key = 'sk_test_3c5311aec4f5a022738b1f03'
    subscription=Payjp::Subscription.create(
        plan: 'premium',
        customer: "#{current_user.customer_id}"
    )
    update(subscription_id:subscription.id)
    update_subscription(subscription)
  end

  def update_subscription(subscription)
    update(expires_at: Time.zone.at(subscription.current_period_end))
  end

  def delete_subscription
    Payjp.api_key = 'sk_test_3c5311aec4f5a022738b1f03'
    Payjp::Subscription.retrieve(subscription_id).delete
    update(expires_at: nil, subscription_id: nil)
  end

  def member?
    expires_at && (expires_at > Time.now)
  end
end
