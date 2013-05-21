# encoding: UTF-8
module Userable
  extend ActiveSupport::Concern

  included do

    has_many :send_messages, :class_name => "Message", :inverse_of => "send_user"
    has_many :receive_messages, :class_name => "Message", :inverse_of => "target_user"
  end

  def messages
    message_contents = Message.where("$or" => [
                                                    {send_user_id: id, deleted: "0"},
                                                    {target_user_id: id, target_deleted: "0"}
                                                  ]
                                              )
  end

  def unreceived_messages
    Message.unreceived.where(target_user_id: id)
  end
end
