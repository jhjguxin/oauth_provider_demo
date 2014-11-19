# encoding: utf-8
module PushUtility
  # base method push message to push server
  def push_to_socket(message)
    message = message.to_json if message.is_a? Hash

    uri = URI(AppConfig.default[:push_server])

    begin
      socket = TCPSocket.new(uri.host, uri.port)
      socket.send(message,0)
      socket.close
      socket = nil
    rescue => error
      Rails.logger.error("#{error.message}, when call #{__method__}")
    end
  end

  # push_message({message: message, user: user})
  def push_message(arg= {message: nil, user: nil})
    message = arg[:message]
    user = arg[:user]
    user ||= message.target_user

    if message.present? and user.present?
      push_hash = {message: {channel: "/meta/server/push_message", user_id: user.id, data: message.attributes}}
      push_to_socket(push_hash)
    end
  end

  def push_messages(arg = {message: nil, user: nil})
    messages = arg[:messages]
    user = arg[:user]

    if message.is_a?(Array) and user.present?
      push_hash = {
                    message: {channel: "/meta/server/push_messages",
                    user_id: user.id, data: messages.collect{|m| m.attributes}}
                  }
      push_to_socket(push_hash)
    end
  end

  def push_login(client_id = nil, user_id = nil)
    client_id ||= "#{SecureRandom.hex}"
    push_json = {
                  message: {channel: "/meta/client/login",
                  data: {
                          client_id: client_id,
                          user_id: user_id
                        }
                  }
                }.to_json

    begin
      uri = URI(AppConfig.default[:push_server])

      socket = TCPSocket.new(uri.host, uri.port)
      socket.send(push_json,0)
      data = socket.read
      socket = nil
    rescue => error
      Rails.logger.error("#{error.message}, when call #{__method__}")
    end
    data ||= nil
  end
end
