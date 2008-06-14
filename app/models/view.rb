class View < ActiveRecord::Base
  belongs_to :user
  belongs_to :video, :dependent => :delete
  validates_presence_of :user
  validates_presence_of :video
  validates_uniqueness_of :video_id, :scope => 'user_id', :message => "user has already seen this video"
end
