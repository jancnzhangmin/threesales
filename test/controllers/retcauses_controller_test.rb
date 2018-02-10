require 'test_helper'

class RetcausesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get retcauses_index_url
    assert_response :success
  end

end
