require 'test_helper'

class MissingTransfersControllerTest < ActionController::TestCase
  setup do
    @missing_transfer = missing_transfers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:missing_transfers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create missing_transfer" do
    assert_difference('MissingTransfer.count') do
      post :create, missing_transfer: @missing_transfer.attributes
    end

    assert_redirected_to missing_transfer_path(assigns(:missing_transfer))
  end

  test "should show missing_transfer" do
    get :show, id: @missing_transfer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @missing_transfer.to_param
    assert_response :success
  end

  test "should update missing_transfer" do
    put :update, id: @missing_transfer.to_param, missing_transfer: @missing_transfer.attributes
    assert_redirected_to missing_transfer_path(assigns(:missing_transfer))
  end

  test "should destroy missing_transfer" do
    assert_difference('MissingTransfer.count', -1) do
      delete :destroy, id: @missing_transfer.to_param
    end

    assert_redirected_to missing_transfers_path
  end
end
