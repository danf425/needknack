class Booking < ActiveRecord::Base
  attr_accessible :user_id, :space_id, :start_date, :end_date,
                  :approval_status, :total, :service_fee,
                  :booking_rate_daily , :start_hour, :start_minute, :start_ampm, :end_hour, :end_minute, :end_ampm
  #:guest_count

  validates_presence_of :user_id, :space_id, :start_date, :end_date,
                        :approval_status, :total, :service_fee,
                        :booking_rate_daily 
  #:guest_count

has_one :order
  belongs_to :user
  belongs_to :space

  def self.approval_statuses
    {canceled_by_user: -4,
    canceled_by_owner: -3,
              timeout: -2,
             declined: -1,
             unbooked:  0,
              pending:  1,
             approved:  2,
                  -4 => "canceled_by_user",
                  -3 => "canceled_by_owner",
                  -2 => "timeout",
                  -1 => "declined",
                   0 => "unbooked",
                   1 => "pending",
                   2 => "approved"}
  end

  def self.hour_intervals
  ["1","2","3","4","5","6","7","8","9","10","11","12"]
end

def self.minute_intervals
  ["00","15","30","45"]
end

def self.ampm_intervals
  ["AM", "PM"]
end

  ############# BOOKING COST CALCULATIONS ###################################

  def night_count
            Rails.logger.info("End_date: #{end_date.inspect}")
   (self.end_date - self.start_date).to_i
  
  end

  def self.start_math(start_hour, start_minute, start_ampm)

    if (start_ampm == 'AM')
      ampm_var = 0
      minute_var = start_minute.to_i * 60
      hour_var = start_hour.to_i * 3600

      start_total = minute_var + hour_var

      Rails.logger.info("StartTIME: #{start_total.inspect}")
    elsif (start_ampm == 'PM')
      ampm_var = 12 * 3600
      minute_var = start_minute.to_i * 60
      hour_var = start_hour.to_i * 3600

      start_total = minute_var + hour_var + ampm_var
    else

    end
    return start_total
  end
def total_t
  (self.end_time.to_f - self.start_time.to_f) /3600
end

# NEED TO FIX
  def subtotal
    self.booking_rate_daily * self.total_t.to_f
  end

  def service_fee
    self.subtotal * 0.10
  end

  def total
    self.subtotal + self.service_fee
  end

  ############# VALIDATING BOOKING PARAMETERS ###############################

#  def guest_count_valid?
#    self.guest_count < self.space.accommodates
#  end

  def conflicts_with_date?(date)
    date.between(self.start_date, self.end_date)
  end

  def conflicts_with_dates?(start_date, end_date)
    self.start_date < end_date && self.end_date > start_date
  end

  def has_initial_form_attributes
    self.start_date && self.end_date #&& self.guest_count
  end

  def overlapping_requests(status)
    Booking
    .where("space_id = ?"        , self.space_id)
    .where("? < end_date"       , self.start_date)
    .where("? >= start_date"     , self.end_date)
    .where("id != ?"             , self.id)
    .where("approval_status = ?" , Booking.approval_statuses[status])
  end

  def is_free_of_conflicts?
    overlapping_requests(:approved).empty?
  end

  ############# UPDATING BOOKING PARAMETERS #################################

  def update_approval_status(method)
    self.public_send(method)
  end

  def set_approval_status(status)
    self.update_attributes!(approval_status: status)
  end

  def decline_conflicting_pending_requests!
    overlapping_requests(:pending).each { |request| request.decline }
  end

  def cancel_by_user
    self.set_approval_status(Booking.approval_statuses[:canceled_by_user])
  end

  def cancel_by_owner
    self.set_approval_status(Booking.approval_statuses[:canceled_by_owner])
  end

  def decline
    self.set_approval_status(Booking.approval_statuses[:declined])
  end

  def book
    if overlapping_requests(:approved).empty?
      self.set_approval_status(Booking.approval_statuses[:pending])
    end
  end

  def approve
    self.set_approval_status(Booking.approval_statuses[:approved])
    self.decline_conflicting_pending_requests!

    #@recipient = Booking.find(@space.owner_id)
   
  end

end
