ActiveAdmin.register Package do
  permit_params :tracking_number, :delivery_status

  index do
    selectable_column
    id_column
    column :tracking_number
    column :delivery_status
    actions
  end

  filter :tracking_number
  filter :delivery_status

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)

    f.inputs do
      f.input :tracking_number
      f.input :delivery_status
    end
    f.actions
  end

end
