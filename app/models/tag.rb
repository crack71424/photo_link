class Tag < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 45 }
  validates :content, presence: true, length: { maximum: 120 }
  
  has_one_attached :image
  
  has_many :tag_relations, dependent: :destroy
  has_many :added_user, through: :tag_relations, source: :user
  
  
  def self.search(search)
    Tag.all unless search
    Tag.where(['title LIKE ?', "%#{search}%"])
  end

end
