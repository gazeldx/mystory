require 'test_helper'

class RhobbiesControllerTest < ActionController::TestCase
  setup do
    @rhobby = rhobbies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rhobbies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rhobby" do
    assert_difference('Rhobby.count') do
      post :create, rhobby: @rhobby.attributes
    end

    assert_redirected_to rhobby_path(assigns(:rhobby))
  end

  test "should show rhobby" do
    get :show, id: @rhobby.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rhobby.to_param
    assert_response :success
  end

  test "should update rhobby" do
    put :update, id: @rhobby.to_param, rhobby: @rhobby.attributes
    assert_redirected_to rhobby_path(assigns(:rhobby))
  end

  test "should destroy rhobby" do
    assert_difference('Rhobby.count', -1) do
      delete :destroy, id: @rhobby.to_param
    end

    assert_redirected_to rhobbies_path
  end
end
