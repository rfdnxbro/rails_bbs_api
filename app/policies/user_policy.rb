# frozen_string_literal: true

#
# userのポリシークラス
#
class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    me? || admin?
  end

  def create?
    admin?
  end

  def update?
    me? || admin?
  end

  def destroy?
    admin?
  end

  private

  def me?
    @record == @user
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
