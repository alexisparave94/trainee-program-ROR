# frozen_string_literal: true

# Class to manage Product Policy
class ProductPolicy < ApplicationPolicy
  # Class to manage Product Policy Scope
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def create?
    user&.admin?
  end

  def new?
    create?
  end

  def update?
    user&.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user&.admin?
  end
end
