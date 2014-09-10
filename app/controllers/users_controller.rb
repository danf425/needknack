class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    # @comment = Comment.find_by_user_id(current_user.id)
    @comment = Comment.all

    Rails.logger.info("This comment: #{@comment.inspect}")
    @spaces = @user.spaces.page(selected_page)
  end

  def new
    @user = User.new

  end

  def edit
  @user = User.find params[:id]
  end

  def update
  @user = User.find params[:id]

  respond_to do |format|
    if @user.update_attributes(params[:user])
      format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
      format.json { respond_with_bip(@user) }
    else
      format.html { render :action => "edit" }
      format.json { respond_with_bip(@user) }
    end
    end
  end

  def create
    @user = User.new(params[:user])
    Rails.logger.info("PARAMS: #{params.inspect}")
    if params[:user][:email]
      @user.email = params[:user][:email].downcase
    end


    if @user.save
      user_photo = UserPhoto.unattached_photo
      #user_photo.update_attributes(user_id: @user.id)
      login_user!(@user)

      # Deliver the signup email
      UserNotifier.confirm_email(@user).deliver
      Rails.logger.info("Test: #{@user.inspect}")
      redirect_to(@user, :notice => 'Thank you for signing up!')

    else
      flash.now[:errors] = @user.errors
      render :new
    end

  end

end
