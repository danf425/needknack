class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index]

  def show
    @user = User.find_by_token(params[:id])
    @comment = Comment.all
    @spaces = @user.spaces.page(selected_page)
  end

  def new
    @user = User.new

  end

  def edit
  @user = User.find_by_token(params[:id])
  end
end
