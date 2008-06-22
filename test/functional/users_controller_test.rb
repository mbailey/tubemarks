require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert_response :redirect
    end
  end

  def test_should_send_reset_email_to_valid_account
    create_user
    @emails = ActionMailer::Base.deliveries
    @emails.clear
    put :email_reset_code, :email => 'quire@example.com'
    assert_response :success
    assert_equal "We've sent you an email, click the link and reset your password", flash[:notice]
    assert @emails.size > 0
  end

  def test_should_not_send_reset_email_to_invalid_account
    put :email_reset_code, :email => 'non-existant@example.com', :form_submission => "true"
    assert_response :success
    assert_equal "Who are you?", flash[:notice]
  end

  def test_should_not_generate_error_message_on_initial_invocation
    get :email_reset_code
    assert_response :success
    assert_equal nil, flash[:notice]
  end

  def test_reset_password_with_a_valid_link_and_a_good_password
    create_user
    put :email_reset_code, :email => 'quire@example.com'
    user = User.find(:first, :conditions => ["email = ?",'quire@example.com'])
    get :reset_password, :link => user.forgotten_password_link, :password_confirmation => "test", :password => "test"
    assert_response :success
    assert 'test', assigns(:link)
    assert_equal "Password changed successfully", flash[:notice]
  end

  def test_reset_password_with_an_invalid_link_and_a_good_password
    get :reset_password, :link => 'test', :password_confirmation => "test", :password => "test"
    assert_response :success
    assert 'test', assigns(:link)
    assert_equal "We can't find that reset code...try again with a different link", flash[:notice]
  end


  def test_reset_password_with_a_valid_link_and_passwords_that_do_not_match
    get :reset_password, :link => 'test', :password_confirmation => "test", :password => "test1"
    assert_response :success
    assert 'test', assigns(:link)
    assert_equal "Your password must be entered twice and both entries must match", flash[:notice]
  end

  def test_reset_password_with_a_valid_link_and_a_confirmation_but_no_password
    get :reset_password, :link => 'test', :password_confirmation => "test"
    assert_response :success
    assert 'test', assigns(:link)
    assert_equal "Your password must be entered twice and both entries must match", flash[:notice]
  end

  def test_reset_password_with_a_valid_link_and_a_password_but_no_confirmation
    get :reset_password, :link => 'test', :password => "test"
    assert_response :success
    assert 'test', assigns(:link)
    assert_equal "Your password must be entered twice and both entries must match", flash[:notice]
  end

  def test_reset_password_with_a_valid_link_but_no_password
    get :reset_password, :link => 'test'
    assert_response :success
    assert 'test', assigns(:link)
  end

  def test_reset_password_without_a_valid_link
    get :reset_password
    assert_redirected_to '/'
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end




  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
