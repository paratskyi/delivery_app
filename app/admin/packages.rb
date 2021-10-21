ActiveAdmin.register Package do
  decorate_with PackageDecorator
  permit_params :estimated_delivery_time, :delivery_status, courier_ids: []

  member_action :assign_to_courier, method: :patch do
    redirect_to admin_assign_to_courier_path(package_id: params[:id])
  end

  action_item(:assign_to_courier, only: [:show], if: proc { authorized?(:assign_to_courier, resource) }) do
    link_to('Assign to Courier', assign_to_courier_admin_package_path, method: :patch)
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

  show do
    attributes_table do
      row :tracking_number
      row :delivery_status
      row :estimated_delivery_time
      row :created_at
      row :updated_at
    end

    panel 'Couriers' do
      if resource.couriers.empty?
        text_node 'Have no Couriers'
      else
        paginated_collection(resource.couriers.page(params[:page]).per(5), download_links: false) do
          table_for collection, id: 'package_table_couriers' do
            column :id
            column :name
            column :email
          end
        end
      end
    end
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
