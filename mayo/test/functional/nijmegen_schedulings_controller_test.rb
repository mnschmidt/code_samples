require 'test_helper'

class NijmegenSchedulingsControllerTest < ActionController::TestCase
  setup do
    @nijmegen_scheduling = nijmegen_schedulings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nijmegen_schedulings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nijmegen_scheduling" do
    assert_difference('NijmegenScheduling.count') do
      post :create, nijmegen_scheduling: @nijmegen_scheduling.attributes
    end

    assert_redirected_to nijmegen_scheduling_path(assigns(:nijmegen_scheduling))
  end

  test "should show nijmegen_scheduling" do
    get :show, id: @nijmegen_scheduling.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nijmegen_scheduling.to_param
    assert_response :success
  end

  test "should update nijmegen_scheduling" do
    put :update, id: @nijmegen_scheduling.to_param, nijmegen_scheduling: @nijmegen_scheduling.attributes
    assert_redirected_to nijmegen_scheduling_path(assigns(:nijmegen_scheduling))
  end

  test "should destroy nijmegen_scheduling" do
    assert_difference('NijmegenScheduling.count', -1) do
      delete :destroy, id: @nijmegen_scheduling.to_param
    end

    assert_redirected_to nijmegen_schedulings_path
  end
end
