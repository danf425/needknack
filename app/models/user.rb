class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauth_providers => [:facebook]

  has_many :authorizations

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :avatar, :first_name, :last_name, :photo_url, :session_token,
                  :description, :city, :state, :country
  attr_accessible :provider, :uid
#  attr_accessible :current_password
  # Setup accessible (or protected) attributes for your model

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "http://placekitten.com/380/500"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  acts_as_messageable

  letsrate_rater


  validates :first_name, :last_name, :session_token, presence: true
  validates_uniqueness_of :email
  validates_format_of :first_name, :last_name, :with => /^[a-zA-Z]*[a-zA-Z][a-zA-Z]*$/
  validates_format_of :email,:with => Devise::email_regexp

  after_initialize :ensure_session_token
  has_many :comments, :as => :commentable
  has_many :user_photos
  has_many :bookings
  has_many :trips, through: :bookings, source: :space
  has_many :spaces,

  class_name: "Space",
  foreign_key: :owner_id,
  primary_key: :id

  def apply_omniauth(omniauth)
  self.email = omniauth['user_info']['email'] if email.blank?
  authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  # def password_required?
  #   (authentications.empty? || !password.blank?) && super
  # end

  def full_name 
    first_name + " " + last_name 
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.find_by_lowercase_email(email)
    User.where('lower(email) = ?', email.downcase).first
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
  end

  def initiated_bookings
    self.bookings.where("approval_status != 0")
  end


  def photo
    # self.photo_url || "http://placekitten.com/g/400/400"
    photo = self.user_photos.sample
    photo ? photo.url : "http://placekitten.com/g/400/400"
  end

  def photo_small
    # self.photo_url || "http://placekitten.com/g/400/400"
    photo = self.user_photos.sample
    photo ? photo.url_small : "http://placekitten.com/g/400/400"
  end

  def photo_medium
    # self.photo_url || "http://placekitten.com/g/400/400"
    photo = self.user_photos.sample
    photo ? photo.url_medium : "http://placekitten.com/g/400/400"
  end

  def mailboxer_email(object)
  return email
  end

   # def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
   #    user = User.find(:provider => auth.provider, :uid => auth.uid).first
   #    unless user
   #      user = User.create(name:auth.extra.raw_info.name,
   #                           provider:auth.provider,
   #                           uid:auth.uid,
   #                           email:auth.info.email,
   #                           password:Devise.friendly_token[0,20]
   #                           )
   #    end
   #    user
   #  end  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.where(:email => data.email).first
      user
 #     user.first_name
 #     user.last_name
    else # Create a user with a stub password. 
      User.create!(:email => data.email, :first_name => data.first_name, 
        :last_name => data.last_name ,:password => Devise.friendly_token[0,20]) 
    end
  end

   def self.new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
  end


  # protected 
  #   def password_required? 
  #   true 
  # end 



  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
