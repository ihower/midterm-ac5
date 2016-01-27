class Message < ActiveRecord::Base

  belongs_to :user

  has_many :comments, :dependent => :destroy

  def last_comment_summary
    self.comments.last.try(:content).try(:truncate, 20)
  end
  
  scope :pending, -> {where(:status => "pending")}
  scope :completed, -> {where( :status => "completed" )}
  scope :within_days, ->(a){where(["created_at >= ?", Time.now - a.days ])}

end
