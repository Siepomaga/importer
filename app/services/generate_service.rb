class GenerateService < ApplicationService
  def initialize(count:)
    @count = count
  end

  def call
    File.open("tmp/data.csv", "w") do |file|
      file.puts "email,amount,channel,anonymous"

      @count.times do
        email = Faker::Internet.email
        amount = rand(1..1000) / 100.0
        channel = %w[credit_card paypal bitcoin].sample
        anonymous = [ true, false ].sample

        file.puts "#{email},#{amount},#{channel},#{anonymous}"
      end
    end
  end
end
