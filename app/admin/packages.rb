ActiveAdmin.register Package do
  decorate_with PackageDecorator
  permit_params :estimated_delivery_time, :delivery_status

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
