class Micropost < ApplicationRecord
  belongs_to :user

  scope :scope_order, -> {order created_at: :desc}
  scope :microposts_feed, ->user{where user_id: user.following_ids << user.id}

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, I18n.t("picture_size")
    end
  end
end
