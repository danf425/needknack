class CommentsController < ApplicationController
 # load_and_authorize_resource
  # GET /comments
  # GET /comments.xml
  before_filter :authenticate_user!, :except => [:show, :index]
  def index
    @comment = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new
    @user = User.find(params[:user])
    @space = Space.find(params[:space])
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
   # @comment = Comment.new(params[:comment])
   @comment = current_user.comments.build(params[:comment])
      Rails.logger.info("COMMENT: #{@comment.user_id.inspect}")
   Rails.logger.info("COMMENT: #{@comment.inspect}")
  #  respond_to do |format|
      if @comment.save
           Rails.logger.info("COMMENT2: #{@comment.inspect}")
       flash[:success] = "Comment created!"
       redirect_to current_user
      else
      flash.now[:errors] = @user.errors
      render :new
      end
   # end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end

private
  
  def find_commentable
    params.each do |name,value|
      if name=~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end 
  end
end