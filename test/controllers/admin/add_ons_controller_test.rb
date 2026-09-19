require "test_helper"

class Admin::AddOnsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_add_ons_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_add_ons_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_add_ons_edit_url
    assert_response :success
  end
end
