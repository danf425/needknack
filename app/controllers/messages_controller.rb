class MessagesController < ApplicationController
 
  # GET /message/new
  def new
    @user = User.find(params[:user])
    @message = current_user.messages.new
  end
 
  def reply
    @conversation ||= current_user.mailbox.conversations.find(params[:id])
  end
   # POST /message/create
   def create

    @recipient = User.find(params[:user])
=begin
    @conversation = @recipient.mailbox.notifications.find_by_sender_id(current_user.id)

    Rails.logger.info("Conv: #{@conversation.inspect}")
    Rails.logger.info("Conv: #{@recipient.mailbox.notifications.inspect}")
    Rails.logger.info("Conv: #{current_user.mailbox.inspect}")
    if conversation.nil?
=end
      current_user.send_message(@recipient, params[:body], "Empty")
 #   else
  #    current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
#    end
    flash[:notice] = "Message has been sent!"
    redirect_to :conversations
  end
end