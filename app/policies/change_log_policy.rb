# frozen_string_literal: true

# Class to manage Change Log Policy
class ChangeLogPolicy < ApplicationPolicy
  # Class to manage Change Log Policy Scope
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    user&.admin?
  end
end
