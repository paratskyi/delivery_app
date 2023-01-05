class PackageAssignmentService < ApplicationService
  attr_reader :package, :courier_ids

  def initialize(package, courier_ids)
    @package = package
    @courier_ids = courier_ids
  end

  def call
    raise_error_if_invalid!

    package.update(courier_ids: courier_ids.concat(package.courier_ids))
    package.status_assigned!
  rescue AssignmentError => e
    package.errors.add(:couriers, e.message)
    false
  end

  private

  def raise_error_if_invalid!
    raise AssignmentError, 'must be an Array of courier ids' unless courier_ids.is_a?(Array)

    courier_ids.each do |courier_id|
      raise AssignmentError, "\"#{courier_id}\" is invalid id" if !courier_id.is_a?(String) || courier_id.size != 36
      raise AssignmentError, "with \"#{courier_id}\" does not exist" if Courier.where(id: courier_id).empty?
    end
  end
end
