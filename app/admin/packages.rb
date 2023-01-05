ActiveAdmin.register Package do
  decorate_with PackageDecorator
  permit_params :estimated_delivery_time, :delivery_status

  member_action :cancel_package, method: :patch do
    if PackageCancellationService.call(resource)
      flash[:notice] = 'Package was successfully canceled!'
      redirect_to admin_package_path(resource)
    else
      flash[:error] = resource.errors.full_messages
      redirect_back(fallback_location: admin_package_path(resource))
    end
  end

  action_item(:cancel_package, only: [:show], if: proc { authorized?(:cancel_package, resource) }) do
    link_to('Cancel', cancel_package_admin_package_path, method: :patch)
  end

  index do
    selectable_column
    id_column
    column :tracking_number
    column :delivery_status
    column :estimated_delivery_time
    column :created_at
    column :updated_at
    actions
  end

  filter :tracking_number
  filter :delivery_status
  filter :estimated_delivery_time
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)

    f.inputs do
      f.input :delivery_status, as: :select
      f.input :estimated_delivery_time
    end
    f.actions
  end
end
