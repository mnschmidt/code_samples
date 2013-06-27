require 'test_helper'

class PastDuesControllerTest < ActionController::TestCase
  setup do
    @past_due = past_dues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:past_dues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create past_due" do
    assert_difference('PastDue.count') do
      post :create, past_due: @past_due.attributes
    end

    assert_redirected_to past_due_path(assigns(:past_due))
  end

  test "should show past_due" do
    get :show, id: @past_due.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @past_due.to_param
    assert_response :success
  end

  test "should update past_due" do
    put :update, id: @past_due.to_param, past_due: @past_due.attributes
    assert_redirected_to past_due_path(assigns(:past_due))
  end

  test "should destroy past_due" do
    assert_difference('PastDue.count', -1) do
      delete :destroy, id: @past_due.to_param
    end

    assert_redirected_to past_dues_path
  end
end
