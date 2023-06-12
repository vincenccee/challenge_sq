Fabricator(:merchant) do
  title { Faker::Name.name }
  email { Faker::Internet.email }
  live_on { Faker::Date.in_date_period(year: 2023, month: 1) }
  disbursement_frequency { :daily }
  minimum_monthly_fee { 0.0 }
end