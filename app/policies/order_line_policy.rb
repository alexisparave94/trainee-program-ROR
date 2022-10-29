class OrderLinePolicy < ApplicationPolicy
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
    !user || user.customer?
  end

  def edit?
    update?
  end

  def destroy?
    !user || user.customer?
  end
end
