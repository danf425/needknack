class ConversationsController < ApplicationController
  #before_filter :authenticate_user!
  helper_method :mailbox, :conversation

  def index
    @conversations ||= (current_user.mailbox.sentbox | current_user.mailbox.inbox)
  end

  def show
    @conversations ||= (current_user.mailbox.inbox.all | current_user.mailbox.sentbox.all)
  end

  def reply
    current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
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
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    # debugger
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