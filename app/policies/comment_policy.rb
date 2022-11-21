# frozen_string_literal: true

# Class to manage Comments Policy
class CommentPolicy < ApplicationPolicy
  # Class to manage Product Policy Scope
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
    user&.admin?
  end

  def approve_comment?
    user&.admin? || user&.support?
  end
end
