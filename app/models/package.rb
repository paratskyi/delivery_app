class Package < ApplicationRecord
  before_validation { set_tracking_number }

  belongs_to :courier

  enum delivery_status: {
    new: 'new',
    processing: 'processing',
    delivered: 'delivered',
    cancelled: 'cancelled'
  }, _prefix: :status

  validates :delivery_status, inclusion: { in: delivery_statuses.keys }
  validates :tracking_number, presence: true, uniqueness: true
  validates :courier_id, presence: true

  private

  def set_tracking_number
    self.tracking_number = generate_tracking_number if new_record?
  end

  def generate_tracking_number
    TrackingNumber.generate
  end
end
