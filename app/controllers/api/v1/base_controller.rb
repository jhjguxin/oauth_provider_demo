class Api::V1::BaseController < ApplicationController
  include PushUtility

  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  private
  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
