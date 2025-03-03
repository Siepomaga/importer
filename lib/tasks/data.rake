require "csv"

namespace :data do
  desc "Generates fake data"
  task :generate, [ :count ]  => :environment do |_, args|
    count = args[:count].try(:to_i) || 10_000

    Benchmark.bm do |x|
      x.report do
        GenerateService.call(count: count)
      end
    end
  end

  desc "Imports data"
  task import: :environment do
    Payment.delete_all
    User.delete_all

    Benchmark.bm do |x|
      x.report do
        ImportService.call
      end
    end

    puts "Payments: #{Payment.joins(:user).count}"
    puts "Users: #{User.count}"

    puts "Data import completed successfully."
  end
end
