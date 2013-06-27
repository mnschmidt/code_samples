require 'test_helper'

class AttSchedulingsControllerTest < ActionController::TestCase
  setup do
    @att_scheduling = att_schedulings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:att_schedulings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create att_scheduling" do
    assert_difference('AttScheduling.count') do
      post :create, att_scheduling: @att_scheduling.attributes
    end

    assert_redirected_to att_scheduling_path(assigns(:att_scheduling))
  end

  test "should show att_scheduling" do
    get :show, id: @att_scheduling.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @att_scheduling.to_param
    assert_response :success
  end

  test "should update att_scheduling" do
    put :update, id: @att_scheduling.to_param, att_scheduling: @att_scheduling.attributes
    assert_redirected_to att_scheduling_path(assigns(:att_scheduling))
  end

  test "should destroy att_scheduling" do
    assert_difference('AttScheduling.count', -1) do
      delete :destroy, id: @att_scheduling.to_param
    end

    assert_redirected_to att_schedulings_path
  end
end
