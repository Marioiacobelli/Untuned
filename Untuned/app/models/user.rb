class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:spotify]
         
  has_one_attached :image
  has_many :posts, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :notifications, as: :recipient, dependent: :destroy
 
  validates :username, presence: true, uniqueness: true, length: { minimum: 5}

  acts_as_follower
  acts_as_followable
  acts_as_voter

  def self.from_omniauth(auth)

    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.nickname
      user.avatar_url = auth.info.image
      user.birthdate = auth.info.birthdate
      split = auth.info.name.split(" ")
      user.name = split[0]
      user.lastname = split[1]

      user.skip_confirmation!
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["admin", "birthdate", "created_at", "email", "encrypted_password", "id", "lastname", "name", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at", "username","image_attachment_id_eq", "image_attachment_blob_id_eq", "comments_id_eq", "votes_id_eq", "notifications_id_eq", "confirmation_token_cont", "confirmation_token_eq", "confirmation_token_start", "confirmation_token_end", "unconfirmed_email_cont", "unconfirmed_email_eq", "unconfirmed_email_start", "unconfirmed_email_end", "provider_cont", "provider_eq", "provider_start", "provider_end", "uid_cont", "uid_eq", "uid_start", "uid_end", "avatar_url_cont", "avatar_url_eq", "avatar_url_start", "avatar_url_end"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["followings", "follows", "posts"]
  end

end
