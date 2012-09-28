require 'test_helper'

class IdolsControllerTest < ActionController::TestCase
  setup do
    @idol = idols(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:idols)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create idol" do
    assert_difference('Idol.count') do
      post :create, idol: @idol.attributes
    end

    assert_redirected_to idol_path(assigns(:idol))
  end

  test "should show idol" do
    get :show, id: @idol.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @idol.to_param
    assert_response :success
  end

  test "should update idol" do
    put :update, id: @idol.to_param, idol: @idol.attributes
    assert_redirected_to idol_path(assigns(:idol))
  end

  test "should destroy idol" do
    assert_difference('Idol.count', -1) do
      delete :destroy, id: @idol.to_param
    end

    assert_redirected_to idols_path
  end
end
