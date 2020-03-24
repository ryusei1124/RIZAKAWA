require 'test_helper'

class ReservationusersControllerTest < ActionDispatch::IntegrationTest
  test "should get useredit" do
    get reservationusers_useredit_url
    assert_response :success
  end

end
