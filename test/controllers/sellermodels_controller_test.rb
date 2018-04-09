require 'test_helper'

class SellermodelsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sellermodels_index_url
    assert_response :success
  end

end
