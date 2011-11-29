require 'test_helper'

class PortionsControllerTest < ActionController::TestCase
  setup do
    @portion = portions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:portions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create portion" do
    assert_difference('Portion.count') do
      post :create, portion: @portion.attributes
    end

    assert_redirected_to portion_path(assigns(:portion))
  end

  test "should show portion" do
    get :show, id: @portion.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @portion.to_param
    assert_response :success
  end

  test "should update portion" do
    put :update, id: @portion.to_param, portion: @portion.attributes
    assert_redirected_to portion_path(assigns(:portion))
  end

  test "should destroy portion" do
    assert_difference('Portion.count', -1) do
      delete :destroy, id: @portion.to_param
    end

    assert_redirected_to portions_path
  end
end
