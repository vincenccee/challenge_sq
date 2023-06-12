Fabricator(:order) do
  merchant { Fabricate(:merchant) }
  amount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
  purchased_at { Faker::Date.in_date_period(year: 2023, month: 1) }
  disbursement { nil }
end