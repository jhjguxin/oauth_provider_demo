# encoding: UTF-8
module Userable
  extend ActiveSupport::Concern

  included do

    has_many :send_messages, :class_name => "Message", :inverse_of => "send_user"
    has_many :receive_messages, :class_name => "Message", :inverse_of => "target_user"
  end




end
