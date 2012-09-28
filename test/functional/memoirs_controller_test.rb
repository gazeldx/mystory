require 'test_helper'

class MemoirsControllerTest < ActionController::TestCase
  setup do
    @memoir = memoirs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:memoirs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create memoir" do
    assert_difference('Memoir.count') do
      post :create, memoir: @memoir.attributes
    end

    assert_redirected_to memoir_path(assigns(:memoir))
  end

  test "should show memoir" do
    get :show, id: @memoir.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @memoir.to_param
    assert_response :success
  end

  test "should update memoir" do
    put :update, id: @memoir.to_param, memoir: @memoir.attributes
    assert_redirected_to memoir_path(assigns(:memoir))
  end

  test "should destroy memoir" do
    assert_difference('Memoir.count', -1) do
      delete :destroy, id: @memoir.to_param
    end

    assert_redirected_to memoirs_path
  end
end
