class BookingsController < ApplicationController

  before_filter :require_current_user!

  def index
    Rails.logger.info("Params for index: #{params.inspect}")
    Rails.logger.info("SpaceID: #{@space_id.inspect}")
=begin
    Space.all.each do |space|
      Rails.logger.info("SpaceThis: #{space.inspect}")
      if space.owner.id == current_user.id
        @user = User.find_by_id(current_user.id)
        render "bookings/index/user"
      end
    end
=end

    if params[:space_id]
      @space = Space.find_by_id(params[:space_id])
Rails.logger.info("Space1: #{@space.inspect}")
      if @space.owner.id == current_user.id
        render "bookings/index/space"
      else
        flash[:notices] = ["You must log in as the owner of a space in order to view that page"]
        redirect_to @space # probably should be a 403
      end
    else
          Rails.logger.info("PARAMS: #{params.inspect}")
      @user = User.find_by_id(current_user.id)

      Rails.logger.info("Ini: #{@user.initiated_bookings.inspect}")
      render "bookings/index/user"
    end
  end

  def show
    @booking = Booking.find(params[:id])
    @space = Space.find_by_id(@booking.space_id)

    Rails.logger.info("Book_show: #{@current_booking.inspect}")
    Rails.logger.info("Book_show: #{@booking.inspect}")
   # @booking = current_booking
  end

  def edit
    @booking = Booking.find(params[:id])
    @space = Space.find_by_id(params[:space_id])
Rails.logger.info("Params_For_Edit: #{params.inspect}")
    Rails.logger.info("bookedittest3: #{@booking.id.inspect}")
        @booking = current_booking
    redirect_to(:back) unless @booking.user_id == current_user.id

    render :edit
  end

  def new
    @booking = Booking.new
    @space = Space.find_by_id(params[:space_id])
            Rails.logger.info("New_Space: #{@space.inspect}")
    @booking = current_booking
                            Rails.logger.info("New_boking: #{@boking.inspect}")
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

      total_time = 0
      if params[:booking_filters]
        @test = params[:booking_filters]

        Rails.logger.info("time_math11: #{params.inspect}")
        Rails.logger.info("time_math11: #{@test.inspect}")


        @booking.start_time = Booking.start_math(@test[:start_hour], @test[:start_minute], @test[:start_ampm])
        @booking.end_time = Booking.start_math(@test[:end_hour], @test[:end_minute], @test[:end_ampm])

        total_time = (@booking.end_time.to_f - @booking.start_time.to_f) /3600
        minute_time = total_time.modulo(1) * 60
        hour_time = total_time.to_i 

        new_time = hour_time.to_s + ":" + minute_time.to_s
        Rails.logger.info("TOTAL: #{new_time.inspect}")

      end
      total_t = total_time
      Rails.logger.info("time: #{total_time.inspect}")
      #night_count = @booking.end_date - @booking.start_date
     # subtotal    = night_count * @booking.booking_rate_daily
     subtotal    = total_time.to_f * @booking.booking_rate_daily
     Rails.logger.info("subTOTAL: #{subtotal.inspect}")
     @booking.service_fee        = subtotal.to_f * 0.10
     Rails.logger.info("serviceTOTAL: #{@booking.service_fee.inspect}")
     @booking.total              = subtotal + @booking.service_fee
     Rails.logger.info("TOTAL: #{@booking.total.inspect}")
     if @booking.is_free_of_conflicts?
      if @booking.save
        Rails.logger.info("bookedittest1: #{@booking.id.inspect}")
        Rails.logger.info("This bookink: #{@booking.inspect}")
        Rails.logger.info("bookedittest2: #{@booking_id.inspect}")
        session[:booking_id] = @booking.id
        Rails.logger.info("bookedittest1: #{@booking.id.inspect}")
        Rails.logger.info("This bookink: #{@booking.inspect}")
        Rails.logger.info("bookedittest2: #{@booking_id.inspect}")
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

    Rails.logger.info("bookedit: #{@booking.id.inspect}")
        Rails.logger.info("Booking1: #{@booking.inspect}")
   session[:booking_id] = @booking.id

    if @booking.user_id == current_user.id
#      @booking.created_at = Time.now
          Rails.logger.info("Time1: #{@booking.created_at.inspect}")
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
   # @recipient = User.find(@booking.user_id)
  #  current_user.send_message(@recipient, "You have been approved!", "I like your knack.")
    redirect_to(:back)
  end

end