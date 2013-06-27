require 'test_helper'

class SuccessfulTransfersControllerTest < ActionController::TestCase
  setup do
    @successful_transfer = successful_transfers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:successful_transfers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create successful_transfer" do
    assert_difference('SuccessfulTransfer.count') do
      post :create, successful_transfer: @successful_transfer.attributes
    end

    assert_redirected_to successful_transfer_path(assigns(:successful_transfer))
  end

  test "should show successful_transfer" do
    get :show, id: @successful_transfer.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @successful_transfer.to_param
    assert_response :success
  end

  test "should update successful_transfer" do
    put :update, id: @successful_transfer.to_param, successful_transfer: @successful_transfer.attributes
    assert_redirected_to successful_transfer_path(assigns(:successful_transfer))
  end

  test "should destroy successful_transfer" do
    assert_difference('SuccessfulTransfer.count', -1) do
      delete :destroy, id: @successful_transfer.to_param
    end

    assert_redirected_to successful_transfers_path
  end
end
