class ImportService < ApplicationService
  def call
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
