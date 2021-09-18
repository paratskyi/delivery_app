class Package < ApplicationRecord
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
end
