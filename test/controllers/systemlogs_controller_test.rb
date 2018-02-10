require 'test_helper'

class SystemlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @systemlog = systemlogs(:one)
  end

  test "should get index" do
    get systemlogs_url
    assert_response :success
  end

  test "should get new" do
    get new_systemlog_url
    assert_response :success
  end

  test "should create systemlog" do
    assert_difference('Systemlog.count') do
      post systemlogs_url, params: { systemlog: { table: @systemlog.table, textout: @systemlog.textout, userid: @systemlog.userid, userip: @systemlog.userip } }
    end

    assert_redirected_to systemlog_url(Systemlog.last)
  end

  test "should show systemlog" do
    get systemlog_url(@systemlog)
    assert_response :success
  end

  test "should get edit" do
    get edit_systemlog_url(@systemlog)
    assert_response :success
  end

  test "should update systemlog" do
    patch systemlog_url(@systemlog), params: { systemlog: { table: @systemlog.table, textout: @systemlog.textout, userid: @systemlog.userid, userip: @systemlog.userip } }
    assert_redirected_to systemlog_url(@systemlog)
  end

  test "should destroy systemlog" do
    assert_difference('Systemlog.count', -1) do
      delete systemlog_url(@systemlog)
    end

    assert_redirected_to systemlogs_url
  end
end
