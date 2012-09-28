require 'test_helper'

class RenjoysControllerTest < ActionController::TestCase
  setup do
    @renjoy = renjoys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:renjoys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create renjoy" do
    assert_difference('Renjoy.count') do
      post :create, renjoy: @renjoy.attributes
    end

    assert_redirected_to renjoy_path(assigns(:renjoy))
  end

  test "should show renjoy" do
    get :show, id: @renjoy.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @renjoy.to_param
    assert_response :success
  end

  test "should update renjoy" do
    put :update, id: @renjoy.to_param, renjoy: @renjoy.attributes
    assert_redirected_to renjoy_path(assigns(:renjoy))
  end

  test "should destroy renjoy" do
    assert_difference('Renjoy.count', -1) do
      delete :destroy, id: @renjoy.to_param
    end

    assert_redirected_to renjoys_path
  end
end
