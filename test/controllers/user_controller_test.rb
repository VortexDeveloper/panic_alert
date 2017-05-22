require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "should get sign_in" do
    get user_sign_in_url
    assert_response :success
  end

  test "should get sign_up" do
    get user_sign_up_url
    assert_response :success
  end

  test "should get sign_out" do
    get user_sign_out_url
    assert_response :success
  end

end
