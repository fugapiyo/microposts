class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  CONTENT_LENGTH_MAX = 140
  validates :content, presence: true, length: { maximum: CONTENT_LENGTH_MAX }
end
