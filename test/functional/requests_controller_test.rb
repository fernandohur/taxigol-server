require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get wait" do
    get :wait
    assert_response :success
  end

  test "should get confirmation" do
    get :confirmation
    assert_response :success
  end

end
