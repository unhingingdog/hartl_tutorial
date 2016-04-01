require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = " "
    assert !@user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert !@user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert !@user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 251
    assert !@user.valid?
  end

  test "email validation should accept valid email adresses" do
    valid_adresses = %w[user@example.com USER@foo.com A-UJ@greg.COM
                        nige@g.g.co.un h.g@htyd.com dfsdf@condg.jp
                        alice+bob@bob.com bob@bob.co.nz]
    valid_adresses.each do |va|
      @user.email = va
      assert @user.valid?, "Address #{va.inspect} should be valid"
    end
  end

  test "email validation should reject invalid adresses" do
    invalid_adresses = %w[george user@example,come dog.org u.n@ec.
                           greg@gregs_shiz.com foo@bar+baz.com ]
    invalid_adresses.each do |ia|
      @user.email = ia
      assert !@user.valid?, "Address #{ia.inspect} should be invalid"
    end
  end

  test "address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert !duplicate_user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert !@user.valid?
  end

  test "authenticated? should return flase for a user with nil digest" do
    assert_not @user.authenticated?(:remember, ' ')
  end
end
