class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @comment = Comment.all
    @spaces = @user.spaces.page(selected_page)
  end

  def new
    @user = User.new

  end

  def edit
  @user = User.find params[:id]
  end
end
