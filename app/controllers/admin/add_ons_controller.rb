class Admin::AddOnsController < ApplicationController
  before_action :set_add_on, only: [ :edit, :update, :destroy ]
  def index
    @add_ons = AddOn.all.order(created_at: :desc)
  end

  def new
    @add_on = AddOn.new
  end

  def create
    @add_on = AddOn.new(add_on_params)
    if @add_on.save
      redirect_to admin_add_ons_path, notice: "สร้าง Add-on เรียบร้อยแล้ว"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @add_on.update(add_on_params)
      redirect_to admin_add_ons_path, notice: "อัปเดต Add-on เรียบร้อยแล้ว"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @add_on.destroy
    redirect_to admin_add_ons_path, notice: "ลบ Add-on เรียบร้อยแล้ว"
  end

  private

  def set_add_on
    @add_on = AddOn.find(params[:id])
  end

  def add_on_params
    params.require(:add_on).permit(:name, :description, :price_cents, :available)
  end
end
