require "test_helper"

class ProgramsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get programs_new_url
    assert_response :success
  end

  test "should get create" do
    get programs_create_url
    assert_response :success
  end

  test "should get edit" do
    get programs_edit_url
    assert_response :success
  end

  test "should get update" do
    get programs_update_url
    assert_response :success
  end
end
