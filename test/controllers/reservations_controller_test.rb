require 'test_helper'

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should get useredit" do
    get reservations_useredit_url
    assert_response :success
  end

end
