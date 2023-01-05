ActiveAdmin.register_page 'Assign to Courier' do
  menu false

  page_action :assign_couriers_to_package, method: :patch do
    if PackageAssignmentService.call(package, courier_ids)
      flash[:notice] = 'Couriers was successfully assigned!'
      redirect_to admin_package_path(package)
    else
      flash[:error] = package.errors.full_messages
      redirect_back(fallback_location: admin_assign_to_courier_path)
    end
  end

  controller do
    helper_method :package

    private

    def package
      @package ||= Package.find(package_id)
    end

    def package_id
      @package_id ||= params[:package_id]
    end

    def courier_ids
      @courier_ids ||= params[:courier_ids]
    end
  end

  content do
    assign_couriers_to_package_table(package)
  end
end
