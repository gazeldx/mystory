require 'test_helper'

class RblogsControllerTest < ActionController::TestCase
  setup do
    @rblog = rblogs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rblogs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rblog" do
    assert_difference('Rblog.count') do
      post :create, rblog: @rblog.attributes
    end

    assert_redirected_to rblog_path(assigns(:rblog))
  end

  test "should show rblog" do
    get :show, id: @rblog.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rblog.to_param
    assert_response :success
  end

  test "should update rblog" do
    put :update, id: @rblog.to_param, rblog: @rblog.attributes
    assert_redirected_to rblog_path(assigns(:rblog))
  end

  test "should destroy rblog" do
    assert_difference('Rblog.count', -1) do
      delete :destroy, id: @rblog.to_param
    end

    assert_redirected_to rblogs_path
  end
end
