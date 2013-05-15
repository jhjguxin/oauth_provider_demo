class Api::V1::ProfilesController < Api::V1::BaseController
  doorkeeper_for :all
  #doorkeeper_for :index
  #doorkeeper_for :create, :scopes => [:write]

  respond_to :json

  def index
    respond_with Profile.recent
  end

  def show
   respond_with @profile = Profile.find(params[:id])
  end

  def create
    respond_with 'api_v1', Profile.create!(params[:profile])
  end
end
