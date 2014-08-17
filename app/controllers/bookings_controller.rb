class BookingsController < ApplicationController

  before_filter :require_current_user!

  def index
        Rails.logger.info("PARAMS: #{params.inspect}")
    if params[:space_id]
      @space = Space.find_by_id(params[:space_id])

      if @space.owner.id == current_user.id
        render "bookings/index/space"
      else
        flash[:notices] = ["You must log in as the owner of a space in order to view that page"]
        redirect_to @space # probably should be a 403
      end
    else
          Rails.logger.info("PARAMS: #{params.inspect}")
      @user = User.find_by_id(current_user.id)

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
Rails.logger.info("Params_For_Edit: #{params.inspect}")
    redirect_to(:back) unless @booking.user_id == current_user.id

    render :edit
  end

  def new
    @booking = Booking.new
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

      night_count = @booking.end_date - @booking.start_date
      subtotal    = night_count * @booking.booking_rate_daily

      @booking.service_fee        = subtotal * 0.10

      @booking.total              = subtotal + @booking.service_fee

      if @booking.is_free_of_conflicts?
        if @booking.save
    Rails.logger.info("bookedittest1: #{@booking.id.inspect}")
    session[:booking_id] = @booking.id
        Rails.logger.info("bookedittest2: #{@booking.id.inspect}")
          redirect_to edit_space_booking_url(@booking.space_id, @booking.id)
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
    Rails.logger.info("bookedit: #{@booking.id.inspect}")
   session[:booking_id] = @booking.id

    if @booking.user_id == current_user.id
#      @booking.created_at = Time.now
          Rails.logger.info("Time1: #{@booking.created_at.inspect}")
      @booking.update_approval_status("book")
    end

          redirect_to new_order_path
  end

  def approve
    @booking = Booking.find_by_id(params[:id])

    if @booking.space.owner_id == current_user.id
      @booking.update_approval_status("approve")
    end

    redirect_to(:back)
  end

end