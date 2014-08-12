class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
 before_filter :current_booking

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
    @order = Order.new
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
    @order.ip_address = request.remote_ip
                Rails.logger.info("SaveBefore: #{@order.save.inspect}")
    if @order.save!
            Rails.logger.info("Save: #{@order.save.inspect}")
      flash[:notice] = "Succesfully created order."
      redirect_to orders_url
    else
      Rails.logger.info("New: #{params.inspect}")
      render :action => "new"
    end
                Rails.logger.info("End: #{params.inspect}")
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
