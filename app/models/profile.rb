class Profile
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  field :name, type: String
  field :email, type: String
  field :username, type: String

  ## sequence number
  field :profile_id, :type => Integer
  sequence :profile

  scope :recent, limit(5).desc(:_id)
end
