require 'test_helper'

class StudyProceduresControllerTest < ActionController::TestCase
  setup do
    @study_procedure = study_procedures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:study_procedures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create study_procedure" do
    assert_difference('StudyProcedure.count') do
      post :create, :study_procedure => @study_procedure.attributes
    end

    assert_redirected_to study_procedure_path(assigns(:study_procedure))
  end

  test "should show study_procedure" do
    get :show, :id => @study_procedure.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @study_procedure.to_param
    assert_response :success
  end

  test "should update study_procedure" do
    put :update, :id => @study_procedure.to_param, :study_procedure => @study_procedure.attributes
    assert_redirected_to study_procedure_path(assigns(:study_procedure))
  end

  test "should destroy study_procedure" do
    assert_difference('StudyProcedure.count', -1) do
      delete :destroy, :id => @study_procedure.to_param
    end

    assert_redirected_to study_procedures_path
  end
end
