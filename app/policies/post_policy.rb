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
    mine? || admin?
  end

  def destroy?
    mine? || admin?
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
