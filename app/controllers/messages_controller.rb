class MessagesController < ApplicationController
  
  before_filter :authenticate_user!
  # GET /message/new
  def new
   Rails.logger.info("Rowing")   
   @user = User.find(params[:user])
   @message = current_user.messages.new

   @recipient = User.find(params[:user])
   @receipt = @recipient.receipts

   @conversations ||= (current_user.mailbox.sentbox | current_user.mailbox.inbox)
   @ongoing_conversation = current_user.mailbox.inbox.participant(current_user).participant(@recipient)
   if @ongoing_conversation.empty?
    @ongoing_conversation = current_user.mailbox.inbox.participant(@recipient).participant(current_user)
  end



  if @ongoing_conversation.present?
    redirect_to conversation_path(@ongoing_conversation.first)
  end

end

def reply
  @conversation ||= current_user.mailbox.conversations.find(params[:id])
end
   # POST /message/create
   def create
    @recipient = User.find(params[:user])
    @conversation = @recipient.mailbox.notifications
    current_user.send_message(@recipient, params[:body], "Empty")
    flash[:notice] = "Message has been sent!"
    redirect_to :conversations
  end
end