# frozen_string_literal: true

#
# 投稿クラス
#
class Post < ApplicationRecord
  validates :subject, presence: true
end