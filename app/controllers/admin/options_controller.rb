class Admin::OptionsController < ApplicationController
  before_action :set_option, only: [ :edit, :update, :destroy ]
  def index
    @options = Option.includes(:option_choices).all.order(created_at: :desc)
  end

  def new
    @option = Option.new
    # @option.option_choices.build # เตรียมช่องกรอก choice ไว้อย่างน้อย 1 ช่อง
    # เตรียมช่องกรอก Choice เริ่มต้นไว้ 3 ช่อง
    3.times { @option.option_choices.build }
  end

  def create
    @option = Option.new(option_params)
    if @option.save
      redirect_to admin_options_path, notice: "บันทึก Option เรียบร้อยแล้ว"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # ถ้ายังไม่มี choice เลย ให้สร้างช่องว่างไว้ 1 ช่อง
    @option.option_choices.build if @option.option_choices.empty?
  end

  def update
    if @option.update(option_params)
      redirect_to admin_options_path, notice: "อัปเดต Option เรียบร้อยแล้ว"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @option.destroy
    redirect_to admin_options_path, notice: "ลบ Option เรียบร้อยแล้ว"
  end

  private

  def set_option
    @option = Option.find(params[:id])
  end

  def option_params
    params.require(:option).permit(
      :name, :required, :multiple, :position,
      option_choices_attributes: [ :id, :name, :price_cents, :position, :_destroy ] # 👈 Strong Params สำหรับ Choices
    )
  end
end
