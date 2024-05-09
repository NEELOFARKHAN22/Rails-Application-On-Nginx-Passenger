class Post < ApplicationRecord
  belongs_to :user
  has_many :comments,dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  has_many_attached :images, dependent: :destroy




end
