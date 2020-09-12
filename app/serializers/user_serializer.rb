# frozen_string_literal: true

#
# user serializer
#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :admin
end
