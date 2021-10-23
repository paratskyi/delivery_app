class PackageCancellationService < ApplicationService
  attr_reader :package

  def initialize(package)
    @package = package
  end

  def call
    package.status_cancelled!
  rescue StandardError => e
    package.errors.add(:package, e.message)
    false
  end
end
