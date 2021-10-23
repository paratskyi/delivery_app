class PackagePolicy < BasePolicy
  def cancel_package?
    !record.status_new? && !record.status_processing? && update?
  end
end
