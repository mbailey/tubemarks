class ViewsController < ApplicationController
  # GET /views
  # GET /views.xml
  def index
    @views = View.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @views }
    end
  end

  # GET /views/1
  # GET /views/1.xml
  def show
    @view = View.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @view }
    end
  end

  # GET /views/new
  # GET /views/new.xml
  def new
    @view = View.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @view }
    end
  end

  # GET /views/1/edit
  def edit
    @view = View.find(params[:id])
  end

  # POST /views
  # POST /views.xml
  def create
    @view = View.new(:video_id = params[:video], :user_id = current_user)

    respond_to do |format|
      if @view.save
        flash[:notice] = 'View was successfully created.'
        format.html { redirect_to(@view) }
        format.xml  { render :xml => @view, :status => :created, :location => @view }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @view.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /views/1
  # PUT /views/1.xml
  def update
    @view = View.find(params[:id])

    respond_to do |format|
      if @view.update_attributes(params[:view])
        flash[:notice] = 'View was successfully updated.'
        format.html { redirect_to(@view) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @view.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /views/1
  # DELETE /views/1.xml
  def destroy
    @view = View.find(params[:id])
    @view.destroy

    respond_to do |format|
      format.html { redirect_to(views_url) }
      format.xml  { head :ok }
    end
  end
end
