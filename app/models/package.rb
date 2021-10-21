class Package < ApplicationRecord
  before_validation { set_tracking_number }

  has_many :package_assignments
  has_many :couriers, through: :package_assignments

  enum delivery_status: {
    new: 'new',
    processing: 'processing',
    delivered: 'delivered',
    cancelled: 'cancelled',
    assigned: 'assigned'
  }, _prefix: :status

  validates :delivery_status, inclusion: { in: delivery_statuses.keys }
  validates :tracking_number, presence: true, uniqueness: true
  accepts_nested_attributes_for :couriers

  private

  def set_tracking_number
    self.tracking_number = generate_tracking_number if new_record?
  end

  def generate_tracking_number
    TrackingNumber.generate
  end
end
