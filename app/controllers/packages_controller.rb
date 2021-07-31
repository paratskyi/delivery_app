class PackagesController < ApplicationController

  def create
    @package = current_courier.packages.build(package_params)
    if @package.save
      flash[:success] = "Package was successfully created!"
      redirect_to current_courier
    else
      redirect_to current_courier
    end
  end

  private

  def package_params
    params.require(:package).permit(:tracking_number, :delivery_status)
  end
end
