class MessagesController < ApplicationController
  
  before_filter :authenticate_user!
  # GET /message/new
  def new
    @user = User.find(params[:user])
    @message = current_user.messages.new

    @recipient = User.find(params[:user])
    @receipt = @recipient.receipts

   @conversations ||= (current_user.mailbox.sentbox | current_user.mailbox.inbox)
@ongoing_conversation = current_user.mailbox.inbox.participant(current_user).participant(@recipient)
if @ongoing_conversation.empty?
  @ongoing_conversation = current_user.mailbox.inbox.participant(@recipient).participant(current_user)
end

   @test
   @receipt.each do | r |
    Rails.logger.info("Rich: #{r.inspect}")
     @conversations.each do | co |
      Rails.logger.info("Cow: #{co.inspect}")
      @n = co.messages.find_by_id(r.notification_id)
      Rails.logger.info("TEST7: #{@n.inspect}")
      if !@n.nil?
       @test = co.messages unless !@test.nil?
       @test = co.messages + @test unless @test.nil?
       Rails.logger.info("TEST6: #{@test.inspect}")
     end
   end
 end


    if @ongoing_conversation.present?
      redirect_to conversation_path(@ongoing_conversation.first)
end


        Rails.logger.info("CV: #{@receipt.inspect}")
    Rails.logger.info("user: #{@user.inspect}")

    # LOOK AT MESSAGE IN THE HTML

 #  conversation ||= mailbox.conversations.find(params[:id])
#  @receipts = conversation.receipts_for

        Rails.logger.info("Conv: #{@conversation.inspect}")
  end
 
  def reply
    Rails.logger.info("MessageControl:")
    @conversation ||= current_user.mailbox.conversations.find(params[:id])
  end
   # POST /message/create
   def create
    @recipient = User.find(params[:user])
    @conversation = @recipient.mailbox.notifications
        Rails.logger.info("CV: #{@conversation.inspect}")
=begin
    @recipient = User.find(params[:user])
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