require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get contact_create_url
    assert_response :success
  end

end
