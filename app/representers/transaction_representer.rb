# frozen_string_literal: true

# Class to representer a transaction in json
class TransactionRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :user_email, exec_context: :decorator
  property :amount
  property :status
  property :description
  property :created_at

  def user_email
    represented.user.email
  end
end
