# frozen_string_literal: true

# Class to manage Transaction Policy
class TransactionPolicy < ApplicationPolicy
  # Class to manage Transaction Policy Scope
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    user&.admin? || (user&.customer? && record.user_id == user.id)
  end
end
