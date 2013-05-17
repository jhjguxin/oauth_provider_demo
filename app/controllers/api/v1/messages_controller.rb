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
      render json: {sucess: true, message_sequence: message.message_sequence, id: message.id}
    else
      render json: message.errors
    end
  end

  # mark one message `{readed: "1"}`
  def read
    Message.where(id: params[:id]).limit(1).update_all(readed: "1")
    render json: {sucess: true}
  end

  # mark all message between send_user and target_user as `{deleted: "1"}`
  def delete_session
    send_user_id, target_user_id = params[:send_user_id], params[:target_user_id]

    if send_user_id.present? and target_user_id.present?
      Message.delete_session(send_user_id, target_user_id)

      render json: {sucess: true}
    end
  end

  # mark one message `{deleted: "1"}`
  def deletemessage
    Message.where(id: params[:id]).limit(1).delete_all
    render json: {sucess: true}
  end
end
