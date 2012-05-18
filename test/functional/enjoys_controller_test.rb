require 'test_helper'

class EnjoysControllerTest < ActionController::TestCase
  setup do
    @enjoy = enjoys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:enjoys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create enjoy" do
    assert_difference('Enjoy.count') do
      post :create, enjoy: @enjoy.attributes
    end

    assert_redirected_to enjoy_path(assigns(:enjoy))
  end

  test "should show enjoy" do
    get :show, id: @enjoy.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @enjoy.to_param
    assert_response :success
  end

  test "should update enjoy" do
    put :update, id: @enjoy.to_param, enjoy: @enjoy.attributes
    assert_redirected_to enjoy_path(assigns(:enjoy))
  end

  test "should destroy enjoy" do
    assert_difference('Enjoy.count', -1) do
      delete :destroy, id: @enjoy.to_param
    end

    assert_redirected_to enjoys_path
  end
end
