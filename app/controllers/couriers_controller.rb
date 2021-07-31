class CouriersController < ApplicationController
  before_action :set_category, only: %i[show update edit]
  before_action :set_courier, only: %i[show]

  def index
    @couriers = Courier.all
  end

  def show
    @packages = @courier.packages
    @package = current_courier.packages.build
  end

  def new
    @courier = Courier.new
  end

  def create
    @courier = Courier.new(courier_params)
    if @courier.save
      flash[:success] = 'Courier was successfully created!'
      redirect_to @courier
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @courier.update(courier_params)
      flash[:success] = 'Courier was successfully updated!'
      redirect_to @courier
    else
      render 'edit'
    end
  end

  private

  def courier_params
    params.require(:courier).permit(:name, :email)
  end

  def set_category
    @courier = Courier.find(params[:id])
  end

  def set_courier
    session[:courier_id] = @courier.id
  end
end
