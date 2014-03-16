require 'test_helper'

class PrivateMessageControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

  test "should get inbox" do
    get :inbox
    assert_response :success
  end

  test "should get outbox" do
    get :outbox
    assert_response :success
  end

  test "should get get" do
    get :get
    assert_response :success
  end

  test "should get check" do
    get :check
    assert_response :success
  end

end
