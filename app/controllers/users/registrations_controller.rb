
class Users::RegistrationsController < Devise::RegistrationsController

  def build_resource(hash=nil)
    hash[:uid] = User.create_unique_string if hash.present?
    super
  end
end