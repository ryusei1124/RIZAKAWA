require 'test_helper'

class LessonsControllerTest < ActionDispatch::IntegrationTest
  test "should get weekly-schedule" do
    get lessons_weekly-schedule_url
    assert_response :success
  end

end
