require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

def setup
  ActionMailer::Base.deliveries.clear
 @user = users(:michael)
end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    #Invalid Email
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #valid Email
    post password_resets_path, password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    #password reset form
    user = assigns(:user)
    #wrong Email
    get edit_password_reset_path(user.reset_token, email: "" )
    assert_redirected_to root_url
    #wrong reset token
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url
    #Inactive users
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    #right email, right token, and acitvated
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_response :success
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    #invalid password & confirmation
    first_password = @user.password_digest
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "barquux" }
    second_password = @user.reload.password_digest
    assert_equal first_password, second_password
    #assert_select 'div#error_explanation'

    #Blank password
    first_password = @user.password_digest
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "",
                  password_confirmation: "ghlsdfljhsdf" }
    second_password = @user.reload.password_digest
    assert_equal first_password, second_password
    assert_not flash.empty?
    assert_template 'password_resets/edit'

    #Blank password and confirmation
    first_password = @user.password_digest
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "",
                  password_confirmation: "" }
    second_password = @user.reload.password_digest
    assert_equal first_password, second_password
    assert_not flash.empty?
    assert_template 'password_resets/edit'

    #valid password & confirmation
    first_password = @user.password_digest
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "greggreg",
                  password_confirmation: "greggreg" }
          second_password = @user.reload.password_digest
          assert_not_equal first_password, second_password
          assert_not flash.empty?
          assert is_logged_in
          assert_redirected_to user
  end

end
