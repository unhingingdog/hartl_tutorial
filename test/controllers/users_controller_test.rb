require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @other_user = users(:greg)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select "title", "Sign up | Ruby on Rails Tutorial Sample App"
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { name: @user.name,
                                                                  email: @user.email  }
    #assert !flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect if user attempts to edit another user" do
    log_in_as(@other_user)
    get :edit, id: @user
    #assert !flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect if user attempts to update another user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name,
                                                                  email: @user.email  }
    #assert !flash.empty?
    assert_redirected_to root_url
  end

end
