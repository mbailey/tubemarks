class Mark < ActiveRecord::Base
  belongs_to :user
  belongs_to :video, :dependent => :delete
  validates_presence_of :user
  validates_presence_of :video
  validates_uniqueness_of :video_id, :scope => 'user_id', :message => "you've already bookmarked this video"

  def before_destroy
    self.video.destroy if self.video.marks.count < 2
  end
end
