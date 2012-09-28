require 'test_helper'

class RnotesControllerTest < ActionController::TestCase
  setup do
    @rnote = rnotes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rnotes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rnote" do
    assert_difference('Rnote.count') do
      post :create, rnote: @rnote.attributes
    end

    assert_redirected_to rnote_path(assigns(:rnote))
  end

  test "should show rnote" do
    get :show, id: @rnote.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rnote.to_param
    assert_response :success
  end

  test "should update rnote" do
    put :update, id: @rnote.to_param, rnote: @rnote.attributes
    assert_redirected_to rnote_path(assigns(:rnote))
  end

  test "should destroy rnote" do
    assert_difference('Rnote.count', -1) do
      delete :destroy, id: @rnote.to_param
    end

    assert_redirected_to rnotes_path
  end
end
