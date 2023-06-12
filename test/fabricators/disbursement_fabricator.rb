Fabricator(:disbursement) do
  merchant { Fabricate(:merchant) }
  amount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
  fee { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  disbursement_date { Faker::Date.in_date_period(year: 2023, month: 1) }
end