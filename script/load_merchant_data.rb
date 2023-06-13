require 'csv'
require 'activerecord-import'

class LoadMerchantData
  attr_accessor :file_path

  def initialize(path)
    self.file_path = path
  end

  # LoadMerchantData.new('public/import_csvs/merchants.csv').call
  def call
    ActiveRecord::Base.transaction do
      puts "Creating Merchants"
      items = []
      CSV.foreach(file_path, headers: false) do |row|
        items << row
      end
      Merchant.import merchant_header, formated_items(items)
    end
  end

  private

  def merchant_header
    [:title, :email, :live_on, :disbursement_frequency, :minimum_monthly_fee]
  end

  def formated_items(items)
    rows = []
    items.each{ |row| rows << row.first.split(';') }
    rows.each do |row|
      row[2] = row[2].to_date
      row[3] = row[3] == 'DAILY' ? :daily : :weekly
    end
  end
end