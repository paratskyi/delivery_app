class AssignCouriersToPackageTable < ActiveAdmin::Component
  builder_method :assign_couriers_to_package_table

  def build(package)
    scope = Courier.free_couriers_for(package)
    if scope.empty?
      text_node 'Have no available couriers'
    else
      active_admin_form_for package,
                            url: admin_assign_to_courier_assign_couriers_to_package_path(package_id: package.id),
                            method: :patch do |f|
        paginated_collection(Courier.free_couriers_for(package).page(params[:page]).per(5), download_links: false) do
          table_for collection, id: 'assign_table_couriers' do
            column :couriers do |courier|
              courier_selection_cell courier
            end
            column :id
            column :name
            column :email
          end
        end
        f.actions do
          f.submit 'Assign couriers'
        end
      end
    end
  end
end
