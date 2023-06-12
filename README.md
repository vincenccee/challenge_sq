# README

* Ruby version
ruby 3.0.5p211
Rails 6.1.7.3

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

Project:

- create a service to calculate merchants’ disbursements using the date of the previous day
  - create module for "Merchants" with: REFERENCE; EMAIL; LIVE_ON; DISBURSEMENT_FREQUENCY; MINIMUM_MONTHLY_FEE;
    - & rails generate model Merchants title:string email:string live_on:date disbursement_frequency:integer minimum_monthly_fee:float
    - create a function to check the day of the week using the live_on date
  - create module for "Orders" with: MERCHANT_REFERENCE; AMOUNT; CREATED AT;
    - rails generate model Orders merchant:belongs_to amount:decimal purchesed_at:date
  - create a module for "Disbursements"
    - rails generate model Disbursements merchant:belongs_to amount:decimal, fee:decimal, disbursement_date:date
- create a module for the minimum monthly fee
  - include a logic into the disbursement service to create one when necessary
- create a queue that will run this service daily at 7:50 UTC
- Run a script that will will include all the samples from the CSV files by checking the oldest date and run the service for all days in the sample

Next steps to polish

- Add a validation for the email attribute for merchants with a RegEx for the email format.
- Add validation for the order amount to prevent negative and zero values
- Add validation for disbursement for disbursement date to be uniq
- add some checks into the disbursement calculation service to check if the order already have an disbursement associated with it.
