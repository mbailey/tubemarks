class Video < ActiveRecord::Base
  attr_accessor :url
  has_many :marks
  has_many :views
  has_many :viewers, :through => :views, :source => :user
  has_many :markers, :through => :marks, :source => :user
  belongs_to :adder, 
             :class_name => "User",
             :foreign_key => "adder"
  
  @@youtube = YouTube::Client.new 'QuVOO5nOtDY'
  
  # extract video token from input (may be part of a URL)
  before_validation_on_create :retrieve_video_details
  
  has_finder :marked_by, lambda { |user| 
    case user
      when nil: {}
      when 0: {}
      else {:conditions => ['marks.user_id = ?', user], :include => :marks}
    end
  }
  has_finder :viewed_by, lambda { |user| {:conditions => ['views.user_id = ?', user], :include => :views}}
  has_finder :not_viewed_by, lambda { |user| {:conditions => ['videos.id not in (select views.video_id from views where user_id = ?)', user], :include => :views}}
  
  has_finder :find_by_viewed_status, lambda { |user, status|
    case status
      when 'true' : {:conditions => ['views.user_id = ?', user], :include => :views}
      when 'false' : {:conditions => ['videos.id not in (select views.video_id from views where user_id = ?)', user], :include => :views}
      else {}
    end
  }
    
  has_finder :find_by_viewed_status_no_login, lambda { |seen_videos, status|
    seen_videos ||= [0] # hack: we want the sql to work - mike
    case status
      when 'true' : {:conditions => "videos.id in (#{seen_videos.join(',')})"}
      when 'false' : {:conditions => "videos.id not in (#{seen_videos.join(',')})"}
      else {}
    end
    }
    
  has_finder :filter_private, lambda { |user|
    if user and user != 0 
      {:conditions => ['(videos.private != true or (marks.video_id = videos.id and marks.user_id = ?))', user], :include => :marks}
    else
      {:conditions => "videos.private != true"}
    end
    }
  
  
  # Video.find(:all, :conditions => 'marks.user_id = 2', :include => :marks)
  # named_scope :registered, lambda { |time_ago| { :conditions => ['created_at > ?', time_ago] }
  # has_finder :unpublished :conditions => {:published => false} do
  #     def published_all
  #       find(:all).map(&:publish)
  #     end
  #   end
  
  def marked_by?(user)
    marks.find(:first, :conditions => ['user_id = ?', user])
  end
  
  def viewed_by?(user)
    views.find(:first, :conditions => ['user_id = ?', user])
  end
  
  def add_view(user)
    @view = View.create(:video_id => id, :user_id => user)    
  end
  
  def add_mark(user)
    @mark = View.create(:video_id => id, :user_id => user)    
  end
  
  def self.find_or_create_from_token(token, user)
    Video.find_by_v(token) || Video.create(:v => token, :adder => user)
  end
  
  def validate 
    if title.blank?
      errors.add_to_base("This does not appear to be a valid video") 
    end 
  end 
  
  def retrieve_video_details
    begin
      details = @@youtube.video_details(v)
      self.title = details.title
      self.thumbnail_url = details.thumbnail_url
      self.length_seconds = details.length_seconds
    rescue
      # could not retrieve details from youtube - perhaps invalid videoId?
    end
  end
  
end
