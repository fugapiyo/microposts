class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  
  devise :database_authenticatable,
         :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter]
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable,
  #       :omniauthable, omniauth_providers: [:twitter]
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  #has_secure_password
  has_many :microposts
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :followed_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :followed_users, through: :followed_relationships, source: :follower

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end

  # タイムライン取得
  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        name:     auth.extra.raw_info.screen_name,
        email:    User.dummy_email(auth),
        password: Devise.friendly_token[0, 20],
        comment: auth.extra.raw_info.description,
        place: auth.extra.raw_info.location,
        image_url: auth.extra.raw_info.profile_image_url
      )
    end

    user
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

end
