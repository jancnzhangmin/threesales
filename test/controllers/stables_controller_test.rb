require 'test_helper'

class StablesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stables_index_url
    assert_response :success
  end

end
