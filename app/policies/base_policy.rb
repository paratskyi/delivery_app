class BasePolicy < ApplicationPolicy
  def index?
    user&.enabled?
  end

  def show?
    user&.enabled?
  end

  def create?
    user&.enabled?
  end

  def update?
    user&.enabled?
  end

  def destroy?
    user&.enabled?
  end
end
