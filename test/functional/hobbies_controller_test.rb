require 'test_helper'

class HobbiesControllerTest < ActionController::TestCase
  setup do
    @hobby = hobbies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hobbies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hobby" do
    assert_difference('Hobby.count') do
      post :create, hobby: @hobby.attributes
    end

    assert_redirected_to hobby_path(assigns(:hobby))
  end

  test "should show hobby" do
    get :show, id: @hobby.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hobby.to_param
    assert_response :success
  end

  test "should update hobby" do
    put :update, id: @hobby.to_param, hobby: @hobby.attributes
    assert_redirected_to hobby_path(assigns(:hobby))
  end

  test "should destroy hobby" do
    assert_difference('Hobby.count', -1) do
      delete :destroy, id: @hobby.to_param
    end

    assert_redirected_to hobbies_path
  end
end
