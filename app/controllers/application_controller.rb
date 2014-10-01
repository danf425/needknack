class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper
  include FlickrHelper
  include KaminariHelper
  include BookingsHelper

    helper :all
      
    def current_booking
      if session[:booking_id]
        @current_booking ||= Booking.find(session[:booking_id])
      end
      if session[:booking_id].nil?
        @current_booking = Booking.create!
        session[:booking_id] = @current_booking.id
      end
      @current_booking
    end

end
  
