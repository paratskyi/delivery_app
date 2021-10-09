ActiveAdmin.register Courier do
  permit_params :name, :email

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :created_at
    actions
  end

  filter :name
  filter :email

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)

    f.inputs do
      f.input :name
      f.input :email
    end
    f.actions
  end
end
