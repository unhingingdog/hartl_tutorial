require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "invalid edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    get edit_user_path(@user)
    patch user_path(@user), user: { name: "" }
    assert_template 'users/edit'
  end

  test "sucessful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    get edit_user_path(@user)
    name = "Mike"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name,
                                                                  email: email,
                                                                  password: "",
                                                                  password_confirmation: "" }
    assert !flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
