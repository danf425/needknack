class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
 before_filter :current_booking

 def express_checkout
        Rails.logger.info("Express_currentbooking: #{@current_booking.inspect}")
           # Rails.logger.info("Express_booking.id: #{@booking.id.inspect}")
  Rails.logger.info("Price_in_cents2: #{current_booking.build_order.price_in_cents.inspect}")
  response = EXPRESS_GATEWAY.setup_purchase(current_booking.build_order.price_in_cents,
    ip: request.remote_ip,
    return_url: new_order_url,
    cancel_return_url: orders_url,
    currency: "USD",
    allow_guest_checkout: true,
    items: [{name: "Order", description: "Order description", quantity: "1", amount: current_booking.build_order.price_in_cents}]
  )
  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
end

  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
   # @order = Order.new
   Rails.logger.info("New_currentbooking: #{@current_booking.inspect}")
   @order = Order.new(:express_token => params[:token])
    @space = Space.find_by_id(@current_booking.space_id)
   Rails.logger.info("Booking_ID: #{@order.booking_id.inspect}")  
   Rails.logger.info("Space_ID: #{@space_id.inspect}")  
   Rails.logger.info("Space: #{@Space.inspect}")  

  Rails.logger.info("New_params: #{params.inspect}")
#Rails.logger.info("New_express: #{express_token.inspect}")
Rails.logger.info("New_token: #{@token.inspect}")
Rails.logger.info("New_order: #{@order.inspect}")
Rails.logger.info("New_credit: #{@credit_card.inspect}")
end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end


  def create
@order = current_booking.build_order(params[:order])
    Rails.logger.info("Params-create: #{params.inspect}")
        Rails.logger.info("Booking-create: #{@current_booking.inspect}")
         Rails.logger.info("Order-create: #{@order.inspect}")
    @order.ip_address = request.remote_ip
    Rails.logger.info("SaveBefore: #{@order.save.inspect}")
    if @order.save!
          Rails.logger.info("Save: #{@order.purchase.inspect}")
#      if @order.purchase
        Rails.logger.info("Purchase: #{@order.purchase.inspect}")
            @space = Space.find_by_id(@current_booking.space_id)
       @recipient = User.find(@space.owner_id)
    current_user.send_message(@recipient, "I would like to reserve you.", "I like your knack.")

      flash[:notice] = "Succesfully created order."
      # TODO: CHANGE URL
      redirect_to orders_url
    #  else
    #    render :action => "failure"
     # end

    else
      Rails.logger.info("New: #{@order.purchase.inspect}")
      render :action => "new"
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
end
