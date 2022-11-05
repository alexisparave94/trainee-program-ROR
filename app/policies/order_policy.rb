# frozen_string_literal: true

# Class to manage Order Policy
class OrderPolicy < ApplicationPolicy
  # Class to manage Order Policy Scope
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    user&.customer?
  end

  def update?
    user&.customer? && record.user_id == user.id
  end

  def show?
    user&.customer? && record.user_id == user.id
  end
end
