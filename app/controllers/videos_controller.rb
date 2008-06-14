class VideosController < ApplicationController
  before_filter :login_required, :only => [:create, :update, :destroy]
  before_filter :set_prefs
  # GET /videos
  # GET /videos.xml
  def index
    
    if logged_in?
      @videos = Video.find_by_viewed_status(current_user, session[:seen]).marked_by(session[:marked_by].to_i).filter_private(params[:marked_by].to_i || current_user).paginate(:page => params[:page], :per_page => 5, :order => 'videos.created_at DESC')
    else
      @videos = Video.find_by_viewed_status_no_login(session[:views], session[:seen]).marked_by(session[:marked_by].to_i).filter_private(session[:marked_by].to_i).paginate(:page => params[:page], :per_page => 5, :order => 'videos.created_at DESC')
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
  end

  # GET /videos/1
  # GET /videos/1.xml
  def show
    @video = Video.find(params[:id])
    
    add_view(@video)

    respond_to do |format|
      format.js {render :partial => 'video'}
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /videos/new
  # GET /videos/new.xml
  def new
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.xml
  def create
    @videos = Video.paginate(:page => params[:page], :per_page => 10, :order => 'updated_at DESC')
    @video = Video.new(params[:video])
    
    respond_to do |format|
      if @video.save
        flash[:notice] = 'Video was successfully added.'
        format.html { redirect_to(@video) }
        format.xml  { render :xml => @video, :status => :created, :location => @video }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /videos/1
  # PUT /videos/1.xml
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        flash[:notice] = 'Video was successfully updated.'
        format.html { redirect_to(@video) }
        format.xml  { head :ok }
        format.js {render :partial => 'toggle_private', :locals => {:video => @video}}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.xml
  def destroy
    @video = Video.find(params[:id])

      respond_to do |format|
        if current_user.is_admin?
          @video.destroy
          format.html { redirect_to(videos_url) }
          format.xml  { head :ok }
        else
          format.html { render :action => "index" }
        end
      end
  end
end
