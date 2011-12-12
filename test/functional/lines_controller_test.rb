require 'test_helper'

class LinesControllerTest < ActionController::TestCase
  setup do
    @line = lines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line" do
    assert_difference('Line.count') do
      post :create, line: @line.attributes
    end

    assert_redirected_to line_path(assigns(:line))
  end

  test "should show line" do
    get :show, id: @line.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @line.to_param
    assert_response :success
  end

  test "should update line" do
    put :update, id: @line.to_param, line: @line.attributes
    assert_redirected_to line_path(assigns(:line))
  end

  test "should destroy line" do
    assert_difference('Line.count', -1) do
      delete :destroy, id: @line.to_param
    end

    assert_redirected_to lines_path
  end
end
