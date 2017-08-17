class UsersController < ApplicationController
  before_action :logged_in?,only:[:show]

  def show
    @user=User.find(params[:id])
  end

  private

  def logged_in?
    redirect_to root_path unless current_user
  end
end