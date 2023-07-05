# frozen_string_literal: true

class HardJob
  include Sidekiq::Job

  def perform(category, message)
    User.where(category: category).first.tap do |user|
      user&.update(last_message: message)
    end
  rescue => e
    puts "Job failed: #{e.message}"
    raise e
  end
end
