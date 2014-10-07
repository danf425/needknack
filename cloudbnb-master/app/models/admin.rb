class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #      :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body


  devise :database_authenticatable, :rememberable
  attr_accessible :email, :password, :password_confirmation, :god_mode, :reports_only, :remember_me
        
end


#admin = Admin.new(:email => 'admin@gmail.com', :password => 'admin', :god_mode => true, :reports_only => false)
#admin.save