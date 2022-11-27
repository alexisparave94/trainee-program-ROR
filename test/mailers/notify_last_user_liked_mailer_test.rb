# frozen_string_literal: true

require 'test_helper'

class NotifyLastUserLikedMailerTest < ActionMailer::TestCase
  test 'should notify a user that a product he liked reaches 3 of stock' do
    product = create(:product)
    user = create(:user)

    # Create the email and store it for further assertions
    email = NotifyLastUserLikedMailer.notify({ email: user.email, products: [product] })

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ['support@mail.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Products that you liked has low stock', email.subject
  end
end
