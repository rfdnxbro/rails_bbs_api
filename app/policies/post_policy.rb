# frozen_string_literal: true

#
# postのポリシークラス
#
class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    @user.present?
  end

  def update?
    @record.user == @user
  end

  def destroy?
    @record.user == @user
  end

  #
  # scope
  #
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
