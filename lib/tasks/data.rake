require "csv"

namespace :data do
  desc "Generates fake data"
  task :generate, [:count]  => :environment do |_, args|
    count = args[:count].try(:to_i) || 10_000

    Benchmark.bm do |x|
      x.report do
        File.open("tmp/data.csv", "w") do |file|
          file.puts "email,amount,channel,anonymous"

          count.times do
            email = Faker::Internet.email
            amount = rand(1..1000) / 100.0
            channel = %w[credit_card paypal bitcoin].sample
            anonymous = [ true, false ].sample

            file.puts "#{email},#{amount},#{channel},#{anonymous}"
          end
        end
      end
    end
  end

  desc "Imports data"
  task import: :environment do
    ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
    ActiveRecord::Base.connection.truncate("payments")
    ActiveRecord::Base.connection.truncate("users")
    ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1")

    Benchmark.bm do |x|
      x.report do
        CSV.foreach("tmp/data.csv", headers: true) do |row|
          user = User.find_or_create_by(email: row["email"])

          user.payments.create!(
            amount: row["amount"],
            channel: row["channel"],
            anonymous: row["anonymous"]
          )
        end
      end
    end
  end
end
