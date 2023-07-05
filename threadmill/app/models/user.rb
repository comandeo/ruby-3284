# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  field :last_name, type: String
  field :category, type: String
  field :last_message, type: String
end
