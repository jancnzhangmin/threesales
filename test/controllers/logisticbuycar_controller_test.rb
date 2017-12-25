require 'test_helper'

class LogisticbuycarControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get logisticbuycar_index_url
    assert_response :success
  end

  test "should get edit" do
    get logisticbuycar_edit_url
    assert_response :success
  end

end
