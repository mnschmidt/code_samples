require 'test_helper'

class SequenceTypesControllerTest < ActionController::TestCase
  setup do
    @sequence_type = sequence_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sequence_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sequence_type" do
    assert_difference('SequenceType.count') do
      post :create, :sequence_type => @sequence_type.attributes
    end

    assert_redirected_to sequence_type_path(assigns(:sequence_type))
  end

  test "should show sequence_type" do
    get :show, :id => @sequence_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @sequence_type.to_param
    assert_response :success
  end

  test "should update sequence_type" do
    put :update, :id => @sequence_type.to_param, :sequence_type => @sequence_type.attributes
    assert_redirected_to sequence_type_path(assigns(:sequence_type))
  end

  test "should destroy sequence_type" do
    assert_difference('SequenceType.count', -1) do
      delete :destroy, :id => @sequence_type.to_param
    end

    assert_redirected_to sequence_types_path
  end
end
