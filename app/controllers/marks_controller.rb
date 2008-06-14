class MarksController < ApplicationController
  before_filter :login_required, :only => [:create, :update, :destroy]
  protect_from_forgery :only => [:update, :destroy]
  
  # GET /marks
  # GET /marks.xml
  def index
    @marks = Mark.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @marks }
    end
  end

  # GET /marks/1
  # GET /marks/1.xml
  def show
    @mark = Mark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mark }
    end
  end

  # GET /marks/new
  # GET /marks/new.xml
  def new
    @mark = Mark.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mark }
    end
  end

  # GET /marks/1/edit
  def edit
    @mark = Mark.find(params[:id])
  end

  # POST /marks
  # POST /marks.xml
  def create
    
    if params[:url]
      token = extract_token_from_url(params[:url]) # in application.rb
      @video = Video.find_or_create_from_token(token, current_user)
    else
      @video = Video.find(params[:video_id])
    end
    
    if @video.errors.empty?
      @mark = Mark.new(:user => current_user, :video => @video)
      @errors = @mark.errors unless @mark.save
    else
      @errors = @video.errors
    end
    
    respond_to do |format|
      unless @errors
        flash[:notice] = 'Video was successfully marked.'
        format.js  { render :update do |page|
            page.replace_html 'flash_notice' , flash[:notice]
            page.replace_html 'viewport', :partial => '/videos/video'
            page.show 'flash_notice'
          end
        }
        format.html { redirect_to videos_path }
        format.xml  { render :xml => @mark, :status => :created, :location => @mark }
      else
        flash[:notice] = @errors.full_messages
        format.js  { render :update do |page|
            page.show 'flash_notice'
            page.replace_html 'flash_notice' , flash[:notice]
          end
        }        
        format.html { redirect_to videos_path }
        format.xml  { render :xml => @mark.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /marks/1
  # PUT /marks/1.xml
  def update
    @mark = Mark.find(params[:id])

    respond_to do |format|
      if @mark.update_attributes(params[:mark])
        flash[:notice] = 'Mark was successfully updated.'
        format.html { redirect_to(@mark) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mark.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /marks/1
  # DELETE /marks/1.xml
  def destroy
    @mark = Mark.find(params[:id])
    
    respond_to do |format|
      if @mark.user == current_user 
        @mark.destroy
        flash[:notice] = "Deleted tubemark."
        format.html { redirect_to(videos_path) }
        format.xml  { head :ok }
      else
        flash[:notice] = "Failed. You can only delete your own tubemarks."
        format.xml  { render :xml => @mark.errors, :status => :unprocessable_entity }
      end

    end
  end
end
