class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
 before_filter :authenticate_user!
 before_filter :current_booking

 def express_checkout
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
   @order = Order.new(:express_token => params[:token])
   @space = Space.find_by_id(@current_booking.space_id)
 end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end


  def create
    @order = current_booking.build_order(params[:order])
    @order.ip_address = request.remote_ip
    if @order.save!
      if @order.purchase
        @space = Space.find_by_id(@current_booking.space_id)
        @recipient = User.find(@space.owner_id)

   @conversations ||= (current_user.mailbox.sentbox | current_user.mailbox.inbox)
   @ongoing_conversation = current_user.mailbox.inbox.participant(current_user).participant(@recipient)
   if @ongoing_conversation.empty?
    @ongoing_conversation = current_user.mailbox.inbox.participant(@recipient).participant(current_user)
  end
Rails.logger.info("YO!: #{@ongoing_conversation.first.inspect}")


  if @ongoing_conversation.present?
    current_user.reply_to_conversation(@ongoing_conversation.first, "I would like to reserve you.")
  end

      #  current_user.send_message(@recipient, "I would like to reserve you.", "I like your knack.")

        flash[:notice] = "Succesfully created order."

        current_booking.book
        redirect_to @space
      else
        render :action => "new"
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
