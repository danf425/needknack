class ConversationsController < ApplicationController
  #before_filter :authenticate_user!
  helper_method :mailbox, :conversation

  def index
    Rails.logger.info("Inbox: #{current_user.mailbox}")
    Rails.logger.info("Sentbox: #{current_user.mailbox.sentbox.inspect}")
   @conversations ||= (current_user.mailbox.sentbox | current_user.mailbox.inbox)
   Rails.logger.info("Convo: #{@conversations.inspect}")
end

  def create
    current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
    redirect_to conversation
  end



  def show
    @conversations ||= (current_user.mailbox.inbox.all | current_user.mailbox.sentbox.all)
  end

  def reply
    Rails.logger.info("ConvoControl:")
    current_user.reply_to_conversation(conversation, *message_params(:body))
    redirect_to conversation_path(conversation)
  end

    def respond
    Rails.logger.info("SUCCESS!:")
    current_user.reply_to_conversation(conversation, params[:body])
    redirect_to conversation_path(conversation)
  end

   def count
  current_user.mailbox.receipts.where({:is_read => false}).count(:id, :distinct => true).to_s
 end 


  def trashbin
    @trash ||= current_user.mailbox.trash.all
  end

  def trash
    conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to :back
  end

  def empty_trash
    current_user.mailbox.trash.each do |conversation|
      conversation.receipts_for(current_user).update_all(:deleted => true)
    end
    redirect_to :conversations
  end

  def show_inbox
    @inbox = mailbox.inbox.page(params[:page]).per_page(10)
  end

  def show_sentbox
    @sentbox = mailbox.sentbox.page(params[:page]).per_page(10)
  end

  def show_trash
    @trash = mailbox.trash.page(params[:page]).per_page(10)
  end

  private

  def mailbox
    @mailbox ||= current_user.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end

  def conversation_params(*keys)
    fetch_params(:conversation, *keys)

  end

  def message_params(*keys)
    Rails.logger.info("Tom: #{params.inspect}")
    Rails.logger.info("Ford: #{keys.inspect}")
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    # debugger
    Rails.logger.info("Fd: #{key.inspect}") 
    Rails.logger.info("Fd: #{subkeys.inspect}")
    test = params[key]
    Rails.logger.info("Fod: #{test.inspect}")       
    params[key].instance_eval do
      # debugger
      case subkeys.size
        when 0 then
          self
        when 1 then
          self[subkeys.first]
        else
          subkeys.map { |k| self[k] }
      end
    end
  end
end