class Post < ActiveRecord::Base

  validates :title, presence: true, length: { maximum: 60 }
  validates :content, presence: true, length: { in: 10..140 }

  belongs_to :user
end
