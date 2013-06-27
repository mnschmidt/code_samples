require 'test_helper'

class LeidenSchedulingsControllerTest < ActionController::TestCase
  setup do
    @leiden_scheduling = leiden_schedulings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:leiden_schedulings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create leiden_scheduling" do
    assert_difference('LeidenScheduling.count') do
      post :create, leiden_scheduling: @leiden_scheduling.attributes
    end

    assert_redirected_to leiden_scheduling_path(assigns(:leiden_scheduling))
  end

  test "should show leiden_scheduling" do
    get :show, id: @leiden_scheduling.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @leiden_scheduling.to_param
    assert_response :success
  end

  test "should update leiden_scheduling" do
    put :update, id: @leiden_scheduling.to_param, leiden_scheduling: @leiden_scheduling.attributes
    assert_redirected_to leiden_scheduling_path(assigns(:leiden_scheduling))
  end

  test "should destroy leiden_scheduling" do
    assert_difference('LeidenScheduling.count', -1) do
      delete :destroy, id: @leiden_scheduling.to_param
    end

    assert_redirected_to leiden_schedulings_path
  end
end
