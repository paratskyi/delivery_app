class Courier < ApplicationRecord
  before_save :downcase_email

  has_many :package_assignments
  has_many :packages, through: :package_assignments

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  private

  def downcase_email
    self.email = email.downcase
  end
end
