# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def bookmarklet
    "javascript:var f = document.createElement('form'); f.style.display = 'none'; document.body.appendChild(f); f.method = 'POST'; f.action = 'http://#{request.env['HTTP_HOST']}/marks'; var s = document.createElement('input'); s.setAttribute('type', 'hidden'); s.setAttribute('name', 'url'); s.setAttribute('value', encodeURIComponent(location.href)); f.appendChild(s);f.submit();"
  end
  
  def owner?(video)
    logged_in? && video.user == current_user
  end
  
  def editing_links(video)
    if mark = video.marked_by?(current_user)
      link_to 'Remove mark!', mark, :confirm => 'Are you sure?', :method => :delete
    else
      link_to 'Mark it!', video_marks_path(video), :method => :post
    end
  end
  
  def delete_link(video)
    if logged_in? && current_user.is_admin?
      "#{link_to 'delete video', video, :confirm => 'Are you sure?', :method => :delete}"
    end
  end
  
  def display_name(user_id)
    User.find(user_id).login
  end
  
  def fmt_time(seconds)
    hrs = seconds / 3600
    leftover = seconds % 3600
    mins = leftover / 60
    secs = leftover % 60
    result = (hrs > 0 ? sprintf("%02d:", hrs) : '')
    result += sprintf("%02d:%02d", mins, secs)
  end
  
end
