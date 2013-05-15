class Api::V1::CredentialsController < Api::V1::BaseController
  doorkeeper_for :all

  respond_to :json

  def me
    respond_with current_resource_owner
  end

end
