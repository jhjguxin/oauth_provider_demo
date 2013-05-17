# encoding: UTF-8
module Messageable
  extend ActiveSupport::Concern

  included do

    # two user all messages
    def self.user_session(send_user_id, target_user_id)
      message_contents = GxMessageContent.where("$or" => [
                                                           {send_user_id: send_user_id, target_user_id: target_user_id, deleted: "0"},
                                                           {send_user_id: target_user_id, target_user_id: send_user_id, deleted: "0"}
                                                         ]
                                                )

    end

    # two user all messages
    def self.user_new_session(send_user_id, target_user_id)
      message_contents = GxMessageContent.where("$or" => [
                                                           {send_user_id: send_user_id, target_user_id: target_user_id, deleted: "0", readed: "0"},
                                                           {send_user_id: target_user_id, target_user_id: send_user_id, deleted: "0", readed: "0"}
                                                         ]
                                                )

    end

    def self.delete_session(send_user_id, target_user_id)
      GxMessageContent.user_session({deleted:  "1"})
    end

    # return two user(send_user_id, target_user_id) session which newer(type = "1") or older(type = "0") message_sequence
    def self.two_user_session(send_user_id, target_user_id, message_sequence = nil, type = "0")
      type ||= "0"
      message_sequence = 9999999999 if type.eql? "0" and message_sequence.to_i.eql? 0

      message_contents = GxMessageContent.where("$or" => [
                                                           {send_user_id: send_user_id, target_user_id: target_user_id, deleted: "0"},
                                                           {send_user_id: target_user_id, target_user_id: send_user_id, deleted: "0"}
                                                         ]
                                                )

      if type.eql? "1"
        message_contents = message_contents.where(message_sequence: {"$gt" => message_sequence})
      elsif type.eql? "0"
        message_contents = message_contents.where(message_sequence: {"$lt" => message_sequence})
      end
      message_contents
    end
  end

end
