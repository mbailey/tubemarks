# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c71dd6bcee94c01c6b8338595e1b236b'
  
private 
  
  def set_prefs
    prefs = {:seen => 'false', :marked_by => 'all'}
    prefs.each do |key, default| 
      session[key] = params[key] || session[key] || default
    end
  end
  
  def add_view(video)
    if logged_in?
      video.add_view(current_user.id)
    else
      add_video_to_session(video)
    end
  end
  
  def add_video_to_session(video)
    session[:views] ||= []
    session[:views] << video.id unless session[:views].include?(video.id)
  end
  
  def extract_token_from_url(url)
    token = url
    uri = URI.parse(URI.decode(url))
    if uri.query and match = uri.query.match(/v=([_\-a-zA-Z0-9]*)/)
      token = match[1] if match[1]
    end
    return token
  end
  
  def create_tubemark_in_waiting
    
    # Broke DRY  - repeated from marks_controller 
    if token = extract_token_from_url(session[:tubemark_in_waiting])
      @video = Video.find_or_create_from_token(token, current_user)
      
      if @video.errors.empty?
        @mark = Mark.new(:user => current_user, :video => @video)
        @errors = @mark.errors unless @mark.save
      else
        @errors = @video.errors
      end
      
      if @errors
        flash[:notice] = @errors.full_messages
        session[:return_to] = videos_path
      else
        flash[:notice] = 'Video was successfully marked.'
        session[:return_to] = videos_path
      end
      session[:tubemark_in_waiting] = nil
    end
    
  end
  
end
