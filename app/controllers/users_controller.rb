class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @videos = @user.marked_videos.paginate(:page => params[:page], :per_page => 10, :order => 'videos.updated_at DESC')
  end
  
  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      flash[:notice] = "Thanks for signing up!"
      create_tubemark_in_waiting if session[:tubemark_in_waiting]
      redirect_back_or_default('/')
    else
      render :action => 'new'
    end
  end

end
