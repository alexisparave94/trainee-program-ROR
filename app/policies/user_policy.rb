# frozen_string_literal: true

# Class to manage User Policy
class UserPolicy < ApplicationPolicy
  # Class to manage User Policy Scope
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def create?
    user&.admin?
  end

  def discard?
    user&.admin?
  end

  def restore?
    user&.admin?
  end
end
