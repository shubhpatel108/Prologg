require 'test_helper'

class MailsControllerTest < ActionController::TestCase
  test "should get _show" do
    get :_show
    assert_response :success
  end

end
