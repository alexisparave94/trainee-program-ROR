# frozen_string_literal: true

# Class to manage Sort PORO
class Poro::Sort
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def self.sort_options
    [
      Poro::Sort.new('ASC', 'A-Z'),
      Poro::Sort.new('DESC', 'Z-A'),
      Poro::Sort.new('like', 'Likes')
    ]
  end
end
