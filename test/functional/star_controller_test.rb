require 'test_helper'

class StarControllerTest < ActionController::TestCase
  test "should get crawl" do
    get :crawl
    assert_response :success
  end

end
