class PackagePolicy < BasePolicy
  def assign_to_courier?
    record.status_processing? && update?
  end
end
