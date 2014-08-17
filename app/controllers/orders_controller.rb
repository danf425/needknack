class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
 before_filter :current_booking

 def express_checkout

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
     @order = Order.new(:express_token => params[:token])
Rails.logger.info("newparams: #{params.inspect}")
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end


  def create
    @order = @current_booking.build_order(params[:order])
    Rails.logger.info("Params-create: #{params.inspect}")
        Rails.logger.info("Booking-create: #{@current_booking.inspect}")
         Rails.logger.info("Order-create: #{@order.inspect}")
    @order.ip_address = request.remote_ip
    Rails.logger.info("SaveBefore: #{@order.save.inspect}")
    if @order.save!
          Rails.logger.info("Purchase: #{@order.purchase.inspect}")
      if @order.purchase
      flash[:notice] = "Succesfully created order."
      redirect_to orders_url
      else
        render :action => "failure"
      end

    else
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
