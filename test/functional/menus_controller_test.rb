require 'test_helper'

class MenusControllerTest < ActionController::TestCase
  setup do
    @menu = menus(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:menus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create menu" do
    assert_difference('Menu.count') do
      post :create, menu: @menu.attributes
    end

    assert_redirected_to menu_path(assigns(:menu))
  end

  test "should show menu" do
    get :show, id: @menu.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @menu.to_param
    assert_response :success
  end

  test "should update menu" do
    put :update, id: @menu.to_param, menu: @menu.attributes
    assert_redirected_to menu_path(assigns(:menu))
  end

  test "should destroy menu" do
    assert_difference('Menu.count', -1) do
      delete :destroy, id: @menu.to_param
    end

    assert_redirected_to menus_path
  end
end
