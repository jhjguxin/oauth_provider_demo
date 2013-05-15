class Api::V1::UsersController < Api::V1::BaseController
  doorkeeper_for :all
  # doorkeeper_for :create, :scopes => [:write] # not work but do not know why

  respond_to :json

  def index
    respond_with User.recent
  end

  def create
    respond_with 'api_v1', User.create!(params[:user])
  end
end
