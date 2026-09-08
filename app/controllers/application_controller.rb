class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_cart

  def current_cart
    if session[:cart_id]
      @current_cart ||= Cart.find_by(id: session[:cart_id])
    end

    if @current_cart.nil?
      @current_cart = Cart.create!
      session[:cart_id] = @current_cart.id
    end

    @current_cart
  end

  protected

  def configure_permitted_parameters
    # อนุญาตฟิลด์เพิ่มเติมตอน Sign Up (สมัครสมาชิก)
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :phone, :role ])

    # อนุญาตฟิลด์เพิ่มเติมตอน Edit Account (แก้ไขข้อมูลส่วนตัว)
    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name, :phone ])
  end
end
