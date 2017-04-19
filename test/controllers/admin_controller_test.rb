require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get allusers" do
    get admin_allusers_url
    assert_response :success
  end

  test "should get allnotes" do
    get admin_allnotes_url
    assert_response :success
  end

end
