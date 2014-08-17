class Order < ActiveRecord::Base
  belongs_to :booking
  has_many :transactions, :class_name => "OrderTransaction"
  attr_accessible :card_expires_on, :card_type, :booking_id, :first_name, :ip_address, :last_name, :new, :card_number, :card_verification, :created_at
  attr_accessor :card_number, :card_verification
  validate :validate_card, :on => :create
  

  def purchase
    response = EXPRESS_GATEWAY.purchase(price_in_cents, express_purchase_options)
    Rails.logger.info("Pcredit: #{@credit_card.inspect}")
    Rails.logger.info("Price_in_cents: #{price_in_cents.inspect}")
    Rails.logger.info("Purchased at Before: #{created_at.inspect}")
    Rails.logger.info("Response Before: #{response.inspect}")
    booking.update_attribute(:created_at, Time.now) if response.success?
    Rails.logger.info("Response After: #{response.inspect}")
    Rails.logger.info("Purchased at After: #{created_at.inspect}")
    response.success?
  end

    def express_token=(token)
    self[:express_token] = token
    if new_record? && !token.blank?
      # you can dump details var if you need more info from buyer
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
    end
  end
  
  def price_in_cents
    (booking.total*100).round
  end

  private


  def express_purchase_options
    {
      :ip => ip,
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
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add(:base, message)
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
  end
end