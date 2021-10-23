module ActiveAdmin
  class CommentPolicy < ApplicationPolicy
    Scope = Struct.new(:user, :scope) do
      def resolve
        scope
      end
    end
  end
end
