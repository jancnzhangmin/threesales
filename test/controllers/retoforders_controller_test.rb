require 'test_helper'

class RetofordersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @retoforder = retoforders(:one)
  end

  test "should get index" do
    get retoforders_url
    assert_response :success
  end

  test "should get new" do
    get new_retoforder_url
    assert_response :success
  end

  test "should create retoforder" do
    assert_difference('Retoforder.count') do
      post retoforders_url, params: { retoforder: { selleruser_id: @retoforder.selleruser_id, textout: @retoforder.textout, userid: @retoforder.userid, userip: @retoforder.userip, usertab: @retoforder.usertab } }
    end

    assert_redirected_to retoforder_url(Retoforder.last)
  end

  test "should show retoforder" do
    get retoforder_url(@retoforder)
    assert_response :success
  end

  test "should get edit" do
    get edit_retoforder_url(@retoforder)
    assert_response :success
  end

  test "should update retoforder" do
    patch retoforder_url(@retoforder), params: { retoforder: { selleruser_id: @retoforder.selleruser_id, textout: @retoforder.textout, userid: @retoforder.userid, userip: @retoforder.userip, usertab: @retoforder.usertab } }
    assert_redirected_to retoforder_url(@retoforder)
  end

  test "should destroy retoforder" do
    assert_difference('Retoforder.count', -1) do
      delete retoforder_url(@retoforder)
    end

    assert_redirected_to retoforders_url
  end
end
