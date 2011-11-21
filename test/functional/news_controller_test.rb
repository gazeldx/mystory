require 'test_helper'

class NewsControllerTest < ActionController::TestCase
  setup do
    @news = news(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:news)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create news" do
    assert_difference('News.count') do
      post :create, :news => @news.attributes
    end

    assert_redirected_to news_path(assigns(:news))
  end

  test "should show news" do
    get :show, :id => @news.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @news.to_param
    assert_response :success
  end

  test "should update news" do
    put :update, :id => @news.to_param, :news => @news.attributes
    assert_redirected_to news_path(assigns(:news))
  end

  test "should destroy news" do
    assert_difference('News.count', -1) do
      delete :destroy, :id => @news.to_param
    end

    assert_redirected_to news_index_path
  end
end
