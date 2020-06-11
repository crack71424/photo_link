class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 250 }
  
  def self.search(search)
    Post.all unless search
    Post.where(['content Like ?', "%#{search}%"])
  end
end
