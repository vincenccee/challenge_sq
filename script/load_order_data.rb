require 'csv'
require 'activerecord-import'

class LoadOrderData
  attr_accessor :file_path

  def initialize(path)
    self.file_path = path
  end

  # LoadOrderData.new('public/import_csvs/orders.csv').call
  def call
    ActiveRecord::Base.transaction do
      puts "Creating orders"
      items = []
      CSV.foreach(file_path, headers: false) do |row|
        items << row
      end
      Order.import order_header, formated_items(items)
    end
  end

  private

  def order_header
    [:merchant_id, :amount, :purchased_at]
  end

  def formated_items(items)
    rows = []
    items.each{ |row| rows << row.first.split(';') }
    mapped_mechants = mapping_merchants
    rows.each do |row|
      row[0] = mapped_mechants[row[0]]
      row[2] = row[2].to_date
    end
  end

  def mapping_merchants
    map = {}
    Merchant.each { |merchant| map[merchant.title] = merchant.id }
    return map
  end
end