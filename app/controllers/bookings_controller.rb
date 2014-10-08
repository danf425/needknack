class BookingsController < ApplicationController

#  before_filter :require_current_user!
before_filter :authenticate_user!

def index
  if params[:space_id]
    @space = Space.find_by_id(params[:space_id])
    if @space.owner.id == current_user.id
      render "bookings/index/space"
    else
      flash[:notices] = ["You must log in as the owner of a space in order to view that page"]
        redirect_to @space # probably should be a 403
      end
    else
      @user = User.find_by_id(current_user.id)

      Space.all.each do |space|
        if current_user.id == space.owner_id && 
          (!space.initiated_approve.empty? || !space.initiated_pending.empty? || 
            !space.initiated_decline.empty? || !space.initiated_complete.empty?)
          @booking_flag = true
        else
          @booking_flag = false
        end
        break if @booking_flag == true
      end

      @booking_flag = false if @booking_flag.nil?


      render "bookings/index/user"
    end
  end

  def show
    @booking = Booking.find(params[:id])
    @space = Space.find_by_id(@booking.space_id)
  end

  def edit
    @booking = Booking.find(params[:id])
    @space = Space.find_by_id(params[:space_id])
    @booking = current_booking
    redirect_to(:back) unless @booking.user_id == current_user.id

    render :edit
  end

  def new
    @booking = Booking.new
    @space = Space.find_by_id(params[:space_id])
    @booking = current_booking
  end

  def create
    @booking = Booking.new(params[:booking])
    unless @booking.has_initial_form_attributes
      flash[:notices] = ["you must fill out the booking form in order to book"]
      redirect_to :back
    else
      @booking.user_id            = current_user.id
      @booking.booking_rate_daily = @booking.space.booking_rate_daily
      @booking.approval_status    = Booking.approval_statuses[:unbooked]
      @booking.end_date = @booking.start_date
      total_time = 0
      if params[:booking_filters]
        @test = params[:booking_filters]

        @booking.start_time = Booking.start_math(@test[:start_hour], @test[:start_minute], @test[:start_ampm])
        @booking.end_time = Booking.start_math(@test[:end_hour], @test[:end_minute], @test[:end_ampm])

        total_time = (@booking.end_time.to_f - @booking.start_time.to_f) /3600
        minute_time = total_time.modulo(1) * 60
        hour_time = total_time.to_i 

        new_time = hour_time.to_s + ":" + minute_time.to_s

      end
      total_t = total_time
      subtotal    = total_time.to_f * @booking.booking_rate_daily
      @booking.service_fee        = subtotal.to_f * 0.10
      @booking.total              = subtotal + @booking.service_fee
      if @booking.is_free_of_conflicts?
        if @booking.save
          session[:booking_id] = @booking.id
          redirect_to new_space_booking_url(@booking.space_id)
        else
          render status: 422
        end
      else
        flash[:notices] = ["You must select dates that aren't taken"]
        redirect_to :back
      end
    end
  end

############## Below actions only modify booking approval status ###############

def cancel_by_user
  @booking = Booking.find_by_id(params[:id])

  if @booking.user_id == current_user.id
    @booking.update_approval_status("cancel_by_user")
  end

  redirect_to(:back)
end

def cancel_by_owner
  @booking = Booking.find_by_id(params[:id])

  if @booking.space.owner_id == current_user.id
    @booking.update_approval_status("cancel_by_owner")
  end

  redirect_to(:back)
end

def decline
  @booking = Booking.find_by_id(params[:id])

  if @booking.space.owner_id == current_user.id
    @booking.update_approval_status("decline")
  end

  redirect_to(:back)
end

def book
  @booking = Booking.find_by_id(params[:id])
  @space = Space.find_by_id(params[:space_id])

  session[:booking_id] = @booking.id

  if @booking.user_id == current_user.id

    @booking.update_approval_status("book")
  end

  redirect_to space_path(:id => @booking.space_id)
end

def approve
  @booking = Booking.find_by_id(params[:id])

  if @booking.space.owner_id == current_user.id
    @booking.update_approval_status("approve")
  end
  @recipient = User.find(@booking.user_id)
  current_user.send_message(@recipient, "You have been approved!", "I like your knack.")
  redirect_to(:back)
end

def complete
  @booking = Booking.find_by_id(params[:id])

  if @booking.space.owner_id == current_user.id
    @booking.update_approval_status("complete")
  end

  @order = @booking.build_order(params[:order])
  redirect_to(:back)
end

end