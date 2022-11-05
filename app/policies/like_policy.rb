# frozen_string_literal: true

# Class to manage Like Policy
class LikePolicy < ApplicationPolicy
  # Class to manage Like Policy Scope
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def create?
    user&.customer?
  end

  def destroy?
    user&.customer?
  end
end
