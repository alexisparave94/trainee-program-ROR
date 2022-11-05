# frozen_string_literal: true

# Class to manage Order Line Policy
class OrderLinePolicy < ApplicationPolicy
  # Class to manage Order Line Policy Scope
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def create?
    !user || user.customer?
  end

  def new?
    create?
  end

  def update?
    (!user || user.customer?) && (record.order.user_id == user.id)
  end

  def edit?
    update?
  end

  def destroy?
    (!user || user.customer?) && (record.order.user_id == user.id)
  end
end
