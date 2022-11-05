# frozen_string_literal: true

class OrderLinePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def create?
    !user || user.customer? && record.order.user_id == user.id
  end

  def new?
    create?
  end

  def update?
    !user || user.customer? && record.order.user_id == user.id
  end

  def edit?
    update?
  end

  def destroy?
    !user || user.customer? && record.order.user_id == user.id
  end
end
