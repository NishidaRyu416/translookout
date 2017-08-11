
class SubscriptionController < ApplicationController
  def create
    if current_user.customer_id==nil
      token=params['payjp-token']
      current_user.making_customer(current_user,token)
    end
    current_user.subscription(current_user)
    redirect_to user_path(current_user.id)
  end
  def destroy
    current_user.delete_subscription
    redirect_to user_path(current_user.id)
  end
end