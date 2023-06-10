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

- create a service to calculate merchants’ disbursements using the date of the previous day at 7:50 UTC
  - create module for "Merchants" with: REFERENCE; EMAIL; LIVE_ON; DISBURSEMENT_FREQUENCY; MINIMUM_MONTHLY_FEE;
    - & rails generate model Merchants title:string email:string live_on:date disbursement_frequency:string minimum_monthly_fee:float
    - create a function to check the day of the week using the live_on date
  - create module for "Orders" with: MERCHANT_REFERENCE; AMOUNT; CREATED AT;
  - create a module for "Disbursements" witch can be weekly or dayly
    - the weekly will have a reference to all orders of the week
- create a queue that will run this service daily
- Run a script that will will include all the samples from the CSV files by checking the oldest date and run the service for all days in the sample