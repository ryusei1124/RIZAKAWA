require 'test_helper'

class ReservationsLogControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get reservations_log_index_url
    assert_response :success
  end

end
