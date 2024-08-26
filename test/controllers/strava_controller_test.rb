require "test_helper"

class StravaControllerTest < ActionDispatch::IntegrationTest
  test "should get callback" do
    get strava_callback_url
    assert_response :success
  end
end
