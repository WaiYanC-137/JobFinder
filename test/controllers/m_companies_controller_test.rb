require "test_helper"

class MCompaniesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get m_companies_new_url
    assert_response :success
  end

  test "should get create" do
    get m_companies_create_url
    assert_response :success
  end

  test "should get show" do
    get m_companies_show_url
    assert_response :success
  end

  test "should get edit" do
    get m_companies_edit_url
    assert_response :success
  end

  test "should get update" do
    get m_companies_update_url
    assert_response :success
  end

  test "should get destroy" do
    get m_companies_destroy_url
    assert_response :success
  end
end
