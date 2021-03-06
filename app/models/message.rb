class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Sequence

  include Messageable

  field :send_user_id, type: String
  field :target_user_id, type: String
  field :content, type: String
  # "1" mean is receive
  field :received, type: String, default: "0"
  # "1" mean readed by target_user
  field :readed, type: String, default: "0"
  field :deleted, type: String, default: "0"
  field :target_deleted, type: String, default: "0"

  # group id, create this message in an group
  # field :group_id, type: String

  field :message_sequence, :type => Integer
  sequence :message_sequence

  belongs_to :send_user, class_name: "User", foreign_key: :send_user_id, inverse_of: "send_messages"
  belongs_to :target_user, class_name: "User", inverse_of: :receive_messages

  scope :unreaded, where(target_readed: "0")
  scope :unreceived, where(received: "0")

  scope :undeleted, where(deleted: "0")
  scope :untarget_deleted, where(target_deleted: "0")
end
