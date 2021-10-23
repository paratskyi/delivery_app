class PackageDecorator < Draper::Decorator
  delegate_all

  def delivery_status
    model.delivery_status.capitalize
  end
end
