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

  def permitted_attributes
    if user.admin?
      %i[sku name description price stock]
    elsif user.support?
      %i[sku name description stock]
    end
  end

  def create?
    user&.admin?
  end

  def new?
    create?
  end

  def update?
    user&.admin? || user&.support?
  end

  def edit?
    update?
  end

  def destroy?
    user&.admin?
  end

  def add_tag?
    user&.admin? || user&.support?
  end
end
