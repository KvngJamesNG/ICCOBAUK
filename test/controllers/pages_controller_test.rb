require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get home_url
    assert_response :success
  end

  test "should get contact_us" do
    get contact_us_url
    assert_response :success
  end

  test "should get blog_post" do
    get blog_post_url
    assert_response :success
  end

  test "should get blog_home" do
    get blog_home_url
    assert_response :success
  end

  test "should get about_us" do
    get about_us_url
    assert_response :success
  end

  test "should get faq" do
    get faq_url
    assert_response :success
  end

  test "should get portfolio_item" do
    get portfolio_item_url
    assert_response :success
  end

  test "should get portfolio_overview" do
    get portfolio_overview_url
    assert_response :success
  end

  test "should get events" do
    get events_url
    assert_response :success
  end
end
