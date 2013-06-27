require 'test_helper'

class FreesurferQualitiesControllerTest < ActionController::TestCase
  setup do
    @freesurfer_quality = freesurfer_qualities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:freesurfer_qualities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create freesurfer_quality" do
    assert_difference('FreesurferQuality.count') do
      post :create, :freesurfer_quality => @freesurfer_quality.attributes
    end

    assert_redirected_to freesurfer_quality_path(assigns(:freesurfer_quality))
  end

  test "should show freesurfer_quality" do
    get :show, :id => @freesurfer_quality.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @freesurfer_quality.to_param
    assert_response :success
  end

  test "should update freesurfer_quality" do
    put :update, :id => @freesurfer_quality.to_param, :freesurfer_quality => @freesurfer_quality.attributes
    assert_redirected_to freesurfer_quality_path(assigns(:freesurfer_quality))
  end

  test "should destroy freesurfer_quality" do
    assert_difference('FreesurferQuality.count', -1) do
      delete :destroy, :id => @freesurfer_quality.to_param
    end

    assert_redirected_to freesurfer_qualities_path
  end
end
