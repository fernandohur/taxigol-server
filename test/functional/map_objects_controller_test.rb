require 'test_helper'

class MapObjectsControllerTest < ActionController::TestCase
  setup do
    @map_object = map_objects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:map_objects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create map_object" do
    assert_difference('MapObject.count') do
      post :create, map_object: { category: @map_object.category, description: @map_object.description, latitude: @map_object.latitude, longitude: @map_object.longitude }
    end

    assert_redirected_to map_object_path(assigns(:map_object))
  end

  test "should show map_object" do
    get :show, id: @map_object
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @map_object
    assert_response :success
  end

  test "should update map_object" do
    put :update, id: @map_object, map_object: { category: @map_object.category, description: @map_object.description, latitude: @map_object.latitude, longitude: @map_object.longitude }
    assert_redirected_to map_object_path(assigns(:map_object))
  end

  test "should destroy map_object" do
    assert_difference('MapObject.count', -1) do
      delete :destroy, id: @map_object
    end

    assert_redirected_to map_objects_path
  end
end
