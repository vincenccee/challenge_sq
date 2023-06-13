# README

* Ruby/Rails version
ruby 3.0.5p211
Rails 6.1.7.3

## How to Run instructions

- This is a simple Rails application without interface, so evething is done by console.

`& bundle exec rails console`

- To load the Merchants you will have to run this script into the rails console
  - Sice I changed some of the column's names I removed the header of the csv file and hard coded into the script, so to import remeber to remove the header from the csv.
  - Replace the [csv_file_path] with your path

```LoadMerchantData.new('[csv_file_path]/merchants.csv').call```

- To load the Orders you will have to run this other scrpit
  - Same thing from the above. Remeber to remove the header from the csv

```LoadOrderData.new('[csv_file_path]/orders.csv').call```

- To calculate the disbursement of a specific Merchant you can run the service `DisbursementCalculation` for a specific date

```DisbursementCalculation.new(merchant).run(Date.new(2023, 1, 1))```

- To calculate the minimum monthlt fee of a specific Merchant you can run the service `MinimumMonthlyFeeCalculation` for a specific date of the month

```MinimumMonthlyFeeCalculation.new(merchant).run(Date.new(2023, 1, 1))```

- To run a batch of calculations I created a script that checks the oldest order and the newest one to run the disbursement calculation for every day between these dates. This script will run for every merchant using the date of the loop.
  - At the first day of the month it will call the MinimumMonthlyFeeCalculation service for every merchant to check if a minimum monthly fee is necessary for that merchant.

## Project:

- create a service to calculate merchants’ disbursements using the date of the previous day
  - create module for "Merchants" with: REFERENCE; EMAIL; LIVE_ON; DISBURSEMENT_FREQUENCY; MINIMUM_MONTHLY_FEE;
    - `& rails generate model Merchants title:string email:string live_on:date disbursement_frequency:integer minimum_monthly_fee:float`
    - create a function to check the day of the week using the live_on date
  - create module for "Orders" with: MERCHANT_REFERENCE; AMOUNT; CREATED AT;
    - `rails generate model Orders merchant:belongs_to amount:decimal purchesed_at:date`
  - create a module for "Disbursements"
    - `rails generate model Disbursements merchant:belongs_to amount:decimal, fee:decimal, disbursement_date:date`
- create a module for the minimum monthly fee
  - `rails generate model MinimumMonthlyFee merchant:belongs_to amount:decimal, year:integer, month:integer`
- include a logic into the disbursement service to create one when necessary
- Run a script that will will include all the samples from the CSV files by checking the oldest date and run the service for all days in the sample
- ~~create a queue that will run this service daily at 7:50 UTC~~

## Next steps

- Due to time constraints I didn't create a queue to run the disbursement calculation everyday at 7:50 UTC. But the logic would be the same as the `CalculatePreviousData` script, where would use the current day date.

these are some validations that I noticed while coding that I should add in the future.

- Add a validation for the email attribute for merchants with a RegEx for the email format.
- Add validation for the order amount to prevent negative and zero values
- Add validation for disbursement for disbursement date to be uniq

## result

| Year |Number of disbursements	| Amount disbursed to merchants	| Amount of order fees | Number of monthly fees charged (From minimum monthly fee) |	Amount of monthly fee charged (From minimum monthly fee) |
| ----------- | ----------- | --------------- | ------------- | ------------- | ------------- |
| 2022        | 1471        | 16.471.142,00 € | 153.191,95 €  | 71            | 1.461,73 €    |
| 2023        | 1003        | 17.159.686,00 € | 157.736,02 €  | 5             | 84,21 €       |

```
& Disbursement.where("cast(strftime('%Y', disbursement_date) as int) = ?", 2022).select("COUNT(*) AS count, SUM(amount) AS amount, SUM(fee) AS fee")
{ "count"=>1471, "amount"=>0.16471142e8, "fee"=>0.15319195e6 }

& Disbursement.where("cast(strftime('%Y', disbursement_date) as int) = ?", 2023).select("COUNT(*) AS count, SUM(amount) AS amount, SUM(fee) AS fee")
{ "count"=>1003, "amount"=>0.17159686e8, "fee"=>0.15773602e6 }

& MinimumMonthlyCharge.where(year: 2022).select("COUNT(*) AS count, SUM(amount) AS amount")
{ "count"=>71, "amount"=>0.146173e4 }

& MinimumMonthlyCharge.where(year: 2023).select("COUNT(*) AS count, SUM(amount) AS amount")
{ "count"=>5, "amount"=>0.8420999999999999e2 }
```