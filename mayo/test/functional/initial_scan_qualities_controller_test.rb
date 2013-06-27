require 'test_helper'

class InitialScanQualitiesControllerTest < ActionController::TestCase
  setup do
    @initial_scan_quality = initial_scan_qualities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:initial_scan_qualities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create initial_scan_quality" do
    assert_difference('InitialScanQuality.count') do
      post :create, :initial_scan_quality => @initial_scan_quality.attributes
    end

    assert_redirected_to initial_scan_quality_path(assigns(:initial_scan_quality))
  end

  test "should show initial_scan_quality" do
    get :show, :id => @initial_scan_quality.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @initial_scan_quality.to_param
    assert_response :success
  end

  test "should update initial_scan_quality" do
    put :update, :id => @initial_scan_quality.to_param, :initial_scan_quality => @initial_scan_quality.attributes
    assert_redirected_to initial_scan_quality_path(assigns(:initial_scan_quality))
  end

  test "should destroy initial_scan_quality" do
    assert_difference('InitialScanQuality.count', -1) do
      delete :destroy, :id => @initial_scan_quality.to_param
    end

    assert_redirected_to initial_scan_qualities_path
  end
end
