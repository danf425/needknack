class Order < ActiveRecord::Base
  attr_accessible :action, :amount, :response, :card_number, :card_verification, :cart_id, :ip_address, :first_name, :last_name, :card_type, :card_expires_on, :express_token, :express_payer_id, :created_at
  attr_accessor :action, :amount, :response, :card_number, :card_verification
  
  belongs_to :booking
  has_many :transactions, :class_name => "OrderTransaction"
  
  attr_accessor :card_number, :card_verification
  
#  validate_on_create :validate_card
validate :validate_card, :on => :create


=begin
def purchase
      response = EXPRESS_GATEWAY.purchase(price_in_cents, :ip => ip_address, :token => express_token, :payer_id => express_payer_id)
  Rails.logger.info("Pcredit: #{@credit_card.inspect}")
  Rails.logger.info("Price_in_cents: #{price_in_cents.inspect}")
  Rails.logger.info("Purchased at Before: #{created_at.inspect}")
  Rails.logger.info("Response Before: #{response.inspect}")
  booking.update_attribute(:created_at, DateTime.now) if response.success?
  Rails.logger.info("Response After: #{response.inspect}")
  Rails.logger.info("Purchased at After: #{created_at.inspect}")
  response.success?
  
end
=end

def purchase
    response = EXPRESS_GATEWAY.purchase(price_in_cents, express_purchase_options)
    transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    booking.update_attribute(:created_at, Time.now) if response.success?
      Rails.logger.info("Response?: #{response.inspect}")
      Rails.logger.info("Trans: #{transactions.inspect}")
    response.success?
end

def express_token=(token)
 # #  if token.blank? and !self[:express_token].blank? 
   #   self[:express_token]
   Rails.logger.info("express3: #{@express_token.inspect}")
 #   elsif !token.blank? and self[:express_token].blank?
  #    self[:express_token] = token
  #    write_attribute(:express_token, token)
  Rails.logger.info("express4: #{token.inspect}")
  Rails.logger.info("express5: #{@express_token.inspect}")

  #    if !token.blank?
  #      details = EXPRESS_GATEWAY.details_for(token)
  #      self.first_name = details.params["first_name"]
   #     self.last_name = details.params["last_name"]
   #   end
   # end

   self[:express_token] = token
   if new_record? && !token.blank?
    details = EXPRESS_GATEWAY.details_for(token)
    self.express_payer_id = details.payer_id
    self.first_name = details.params["first_name"]
    self.last_name = details.params["last_name"]
  end
end

def price_in_cents
  (booking.total*100).round
end

private

def process_purchase
  if express_token.blank?

  else
    EXPRESS_GATEWAY.purchase(price_in_cents, express_purchase_options)
  end
end


def express_purchase_options
  {
    :ip => ip_address,
    :token => express_token,
    :payer_id => express_payer_id
  }
end

def purchase_options
  {
    :ip => ip_address,
    :billing_address => {
      :name     => "Ryan Bates",
      :address1 => "123 Main St.",
      :city     => "New York",
      :state    => "NY",
      :country  => "US",
      :zip      => "10001"
    }
  }
end

def validate_card
  if express_token.blank? && !credit_card.valid?
    credit_card.errors.full_messages.each do |message|
      errors.add_to_base message
    end
  end
end

def credit_card
  Rails.logger.info("Credit: #{@credit_card.inspect}")
  @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
    :type               => card_type,
    :number             => card_number,
    :verification_value => card_verification,
    :month              => card_expires_on.month,
    :year               => card_expires_on.year,
    :first_name         => first_name,
    :last_name          => last_name
    )
    Rails.logger.info("Credit2: #{@credit_card.inspect}")
end
end