module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    Scope = Struct.new(:user, :scope) do
      def resolve
        scope
      end
    end

    def index?
      true
    end

    def show?
      true
    end

    def assign_couriers_to_package?
      true
    end
  end
end
