class HomeController < ApplicationController
  def index
  end

  def seed
    1000.times do |i|
      User.create(first_name: "First #{i}", last_name: "Last #{i}", category: category(i))
    end
    redirect_to root_path
  end

  def work_hard
    1000.times do |i|
      HardJob.perform_async(category(i), "message at #{Time.now}")
    end
    redirect_to root_path
  end

  private

  def category(i)
    %w[admin user guest][i % 3]
  end
end
