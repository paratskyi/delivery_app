class TrackingNumber

  def initialize(tracking_number)
    @tracking_number = tracking_number
  end

  def self.generate
    tracking_number = TrackingNumber.new("YA#{generate_digest_sequence}AA")
    if tracking_number.valid?
      tracking_number.to_s
    else
      TrackingNumber.generate
    end
  end

  def self.generate_digest_sequence
    rand(10_000_000..10**8)
  end

  def to_s
    @tracking_number
  end

  def valid?
    Package.find_by(tracking_number: @tracking_number).nil?
  end
end
