require 'test_helper'

class ModelcontsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get modelconts_index_url
    assert_response :success
  end

end
