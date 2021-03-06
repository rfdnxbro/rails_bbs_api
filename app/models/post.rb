# frozen_string_literal: true

#
# 投稿クラス
#
class Post < ApplicationRecord
  belongs_to :user

  validates :subject, presence: true, length: { maximum: 30 }
  validates :body, presence: true, length: { maximum: 100 }
end
