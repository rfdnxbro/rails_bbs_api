# frozen_string_literal: true

#
# post serializer
#
class PostSerializer < ActiveModel::Serializer
  attributes :id, :subject, :body
end
