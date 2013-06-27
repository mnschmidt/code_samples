require 'test_helper'

class UnratedsControllerTest < ActionController::TestCase
  setup do
    @unrated = unrateds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unrateds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unrated" do
    assert_difference('Unrated.count') do
      post :create, unrated: @unrated.attributes
    end

    assert_redirected_to unrated_path(assigns(:unrated))
  end

  test "should show unrated" do
    get :show, id: @unrated.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unrated.to_param
    assert_response :success
  end

  test "should update unrated" do
    put :update, id: @unrated.to_param, unrated: @unrated.attributes
    assert_redirected_to unrated_path(assigns(:unrated))
  end

  test "should destroy unrated" do
    assert_difference('Unrated.count', -1) do
      delete :destroy, id: @unrated.to_param
    end

    assert_redirected_to unrateds_path
  end
end
