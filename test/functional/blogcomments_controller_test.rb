require 'test_helper'

class BlogcommentsControllerTest < ActionController::TestCase
  setup do
    @blogcomment = blogcomments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blogcomments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blogcomment" do
    assert_difference('Blogcomment.count') do
      post :create, blogcomment: @blogcomment.attributes
    end

    assert_redirected_to blogcomment_path(assigns(:blogcomment))
  end

  test "should show blogcomment" do
    get :show, id: @blogcomment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blogcomment.to_param
    assert_response :success
  end

  test "should update blogcomment" do
    put :update, id: @blogcomment.to_param, blogcomment: @blogcomment.attributes
    assert_redirected_to blogcomment_path(assigns(:blogcomment))
  end

  test "should destroy blogcomment" do
    assert_difference('Blogcomment.count', -1) do
      delete :destroy, id: @blogcomment.to_param
    end

    assert_redirected_to blogcomments_path
  end
end
