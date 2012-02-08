require 'test_helper'

class RidolsControllerTest < ActionController::TestCase
  setup do
    @ridol = ridols(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ridols)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ridol" do
    assert_difference('Ridol.count') do
      post :create, ridol: @ridol.attributes
    end

    assert_redirected_to ridol_path(assigns(:ridol))
  end

  test "should show ridol" do
    get :show, id: @ridol.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ridol.to_param
    assert_response :success
  end

  test "should update ridol" do
    put :update, id: @ridol.to_param, ridol: @ridol.attributes
    assert_redirected_to ridol_path(assigns(:ridol))
  end

  test "should destroy ridol" do
    assert_difference('Ridol.count', -1) do
      delete :destroy, id: @ridol.to_param
    end

    assert_redirected_to ridols_path
  end
end
