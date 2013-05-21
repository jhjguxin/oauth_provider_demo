class Api::V1::MessagesController < Api::V1::BaseController
  doorkeeper_for :all
  # accept params from client, then create one message
  # send_user_id, target_user_id is required
  # return message self, or message.errors
  #
  def send_message
    send_user_id, target_user_id, content = params[:send_user_id], params[:target_user_id], params[:conent]
    message_hash = {
                send_user_id: send_user_id,
                target_user_id: target_user_id,
                content: content
              }.keep_if{|k,v| v.present? }
    message = Message.new(message_hash)

    if message.save
      # push message to sockect server
      push_message({message: message})

      render json: {sucess: true, message_sequence: message.message_sequence, id: message.id}
    else
      render json: message.errors
    end
  end

  def get_session
    message_sequence, user_id, target_user_id, type = params[:message_sequence], params[:user_id], params[:target_user_id], params[:type]
    type ||= "0"

    if user_id.present? and target_user_id.present?
      messages = Message.two_user_session(send_user_id, target_user_id, message_sequence, type)
      render json: {sucess: true, messages: messages.collect{|m| m.attributes}}
    end
  end

  # mark one message `{readed: "1"}`
  def read
    Message.where(id: params[:id]).limit(1).update_all(readed: "1")
    render json: {sucess: true}
  end

  # callback from client when message has received
  def receive
    Message.where(id: params[:id]).limit(1).update_all(received: "1")
    render json: {sucess: true}
  end

  # push unread message to client when user is active
  def push_unread
    user = User.where(id: params[:id]).limit(1).first

    if user.present?
      messages = user.unreceived_messages
      push_messages({message: message, user: user})
      render json: {sucess: true}
    end
  end

  # mark all message between send_user and target_user as `{deleted: "1"}`
  def delete_session
    send_user_id = params[:send_user_id], params[:target_user_id]

    if send_user_id.present? and target_user_id.present?
      Message.delete_session(send_user_id, target_user_id)
      render json: {sucess: true}
    end
  end

  # mark one message `{deleted: "1"}`
  def delete_message
    id, user_id = params[:id] , params[:user_id]
    if id.present? and user_id.present?
      Message.delete_message(id , user_id)
      render json: {sucess: true}
    end
  end
end
