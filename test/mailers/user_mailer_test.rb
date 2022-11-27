# frozen_string_literal: true

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'should send email to reset a password user' do
    user = create(:user)

    # Create the email and store it for further assertions
    email = UserMailer.reset_password_instructions(user)

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ['donotreply@example.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Reset password instructions', email.subject
  end
end
