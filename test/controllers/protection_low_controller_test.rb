require 'test_helper'

class ProtectionLowControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get protection_low_index_url
    assert_response :success
  end

end
