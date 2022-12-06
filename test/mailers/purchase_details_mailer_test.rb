# frozen_string_literal: true

require 'test_helper'

class PurchaseDetailsMailerTest < ActionMailer::TestCase
  test 'should notify a user purchase details' do
    order = create(:order)

    # Create the email and store it for further assertions
    email = PurchaseDetailsMailer.purchase_details(order.user.email, order)

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ['support@mail.com'], email.from
    assert_equal [order.user.email], email.to
    assert_equal 'Purchase Details', email.subject
  end

  test 'should notify an incompleted purchase' do
    user = create(:user)

    # Create the email and store it for further assertions
    email = PurchaseDetailsMailer.incompleted_purchase(user.email, 'Rejected')

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ['support@mail.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Incompleted Purchase', email.subject
  end
end
