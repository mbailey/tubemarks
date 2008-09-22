require 'test_helper'
require 'ostruct'
class UserMailerTest < ActionMailer::TestCase
  tests UserMailer
  def test_reset_password
    url = 'http://www.test.com/reset_password'
    user = OpenStruct.new( :email => 'test' , :login => 'Test', :forgotten_password_link => 'aaaaaaaaa')
    @expected.subject = 'Reset Your Tubemarks Password'
    @expected.body    = read_fixture('reset_password')
    @expected.date    = Time.now
    @expected.from    = 'admin@tubemarks.com'
    @expected.to = 'test'

    assert_equal @expected.encoded, UserMailer.create_reset_password(url,user, @expected.date).encoded
  end

end
