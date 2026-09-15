module Admin
  class Admin::ProductsController < ApplicationController
      # TODO: เพิ่ม before_action :authenticate_admin! เพื่อเช็กสิทธิ์ภายหลัง
      before_action :set_product, only: [ :edit, :update, :destroy ]
    def index
      @products = Product.includes(:category).all.order(created_at: :desc)
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
        if @product.save
          redirect_to admin_products_path, notice: "เพิ่มรายการเมนูสำเร็จ!"
        else
          render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
      if @product.update(product_params)
          redirect_to admin_products_path, notice: "อัปเดตเมนูเรียบร้อยแล้ว"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
        redirect_to admin_products_path, notice: "ลบเมนูเรียบร้อยแล้ว", status: :see_other
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :name,
        :description,
        :price_cents,
        :image_url,
        :category,
        :ingredients
        )
    end
  end
end
