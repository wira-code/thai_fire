require "test_helper"

class Admin::ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_reservations_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_reservations_show_url
    assert_response :success
  end

  test "should get update" do
    get admin_reservations_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_reservations_destroy_url
    assert_response :success
  end
end
