require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  test "should get contact_us" do
    get pages_contact_us_url
    assert_response :success
  end

  test "should get blog_post" do
    get pages_blog_post_url
    assert_response :success
  end

  test "should get blog_home" do
    get pages_blog_home_url
    assert_response :success
  end

  test "should get about_us" do
    get pages_about_us_url
    assert_response :success
  end

  test "should get faq" do
    get pages_faq_url
    assert_response :success
  end

  test "should get portfolio_item" do
    get pages_portfolio_item_url
    assert_response :success
  end

  test "should get portfolio_overview" do
    get pages_portfolio_overview_url
    assert_response :success
  end

  test "should get events" do
    get pages_events_url
    assert_response :success
  end
end
