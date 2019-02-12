# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# read in the works csv
=begin 
csv_text = File.read(Rails.root.join('lib', 'seeds', 'Works.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'utf-8', :liberal_parsing => true)
csv.each do |row|
  t = Work.new
  t.id = row[0]
  t.inventory_number = row['InventoryNumber']
  t.artist_number = row['ArtistNumber']
  t.title = row['Title']
  t.type = row['Type']
  if row['FullYear'] == ""
    t.full_year = row['Year']
  else
    t.full_year = row['FullYear']
  end
  t.media = row['Media']
  t.hinw = row['HINW']
  t.hinn = row['HINN']
  t.hind = row['HIND']
  t.winw = row['WINW']
  t.winn = row['WINN']
  t.wind = row['WIND']
  t.dinw = row['DINW']
  t.dinn = row['DINN']
  t.dind = row['DIND']
  t.numerator = row['Numerator']
  t.denominator = row['Denominator']
  t.set = row['Set']
  t.base_net_amount = row['BaseNetAmount']
  t.base_purchase_price = row['BasePurchasePrice']
  t.retail_value = row['RetailValue']
  t.category = row['Category']
  t.image = row['Image']
  t.framed = row['Framed']
  t.frame_condition = row['FrameCondition']
  t.current_owner = row['CurrentOwner']
  t.save
end
=end

# read in the artists csv
csv_text = File.read(Rails.root.join('lib', 'seeds', 'Artists.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'utf-8', :liberal_parsing => true)
csv.each do |row|
  t = Artist.new
  t.id = row[0]
  t.first_name = row['FirstName']
  t.last_name = row['LastName']
  t.dates = row['Dates']
  t.contact_number = row['ContactNumber']
  t.category = row['Category']
  t.save
end

