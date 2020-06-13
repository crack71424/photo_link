class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  has_one_attached :avatar
  has_many :posts, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :tag_relations
  has_many :adding_tags, through: :tag_relations, source: :tag
  
  
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow #userモデルと紐ずけ
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  # 試作feedの定義
  def feed
    Post.where("user_id = ?", id)
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
   # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
     return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  #ユーザーフォロー
  def follow(other_user)
    unless self == other_user
    self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationships = self.relationships.find_by(follow_id: other_user.id)
    relationships.destroy if relationships
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  #def add_tag
    #@user = User.find_by(params[:id])
    #@adding = @user.adding_tags
  #end
  
  def adding(tag)
    unless self.tag_relations.include?(tag)
      self.tag_relations.find_or_create_by(tag_id: tag.id)
    end
  end
  
  def adding?(tag)
    self.adding_tags.include?(tag)
  end
  
  def remove(tag)
    delete_tag = self.tag_relations.find_by(tag_id: tag.id)
    delete_tag.destroy if delete_tag
  end
  
  
end