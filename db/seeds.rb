# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

contact_csv_text = File.read(Rails.root.join('lib','seeds', 'Contacts.csv'))
contact_csv = CSV.parse(contact_csv_text, :headers => true, :encoding => 'utf-8', :liberal_parsing => true)
puts "contacts"
contact_csv.each do |row|
  c = Contact.new
  c.id = row['ContactNumber'] 
  c.description = row['ContactDescription'] #string of company etc if not just name
  c.first_name = row['FirstName']
  c.last_name = row['LastName']
  c.institution = row['Institution']
  c.address1 = row['Address1']
  c.address2 = row['Address2']
  c.city = row['City']
  c.state_prov = row['StateProv']
  c.postal_code = row['PostalCode']
  c.save
end

# read in the artists csv
artist_csv_text = File.read(Rails.root.join('lib', 'seeds', 'Artists.csv'))
artist_csv = CSV.parse(artist_csv_text, :headers => true, :encoding => 'utf-8', :liberal_parsing => true)
puts "artists"
artist_csv.each do |row|
  a = Artist.new
  a.id = row[0] 
  a.first_name = row['FirstName']
  a.last_name = row['LastName']
  a.dates = row['Dates']
  a.category = row['Category']
  a.save
end

work_csv_text = File.read(Rails.root.join('lib', 'seeds', 'Works.csv'))
work_csv = CSV.parse(work_csv_text, :headers => true, :encoding => 'utf-8', :liberal_parsing => true)
puts "works"
work_csv.each do |row|
  w = Work.new
  w.artist = Artist.find(row['ArtistNumber'])
  w.id = row[0]
  w.inventory_number = row['InventoryNumber']
  w.title = row['Title']
  w.art_type = row['Type']
  if row['FullYear'].nil?
    w.full_year = row['Year']
  else
    w.full_year = row['FullYear']
  end
  w.media = row['Media']
  w.hinw = row['HINW']
  w.hinn = row['HINN']
  w.hind = row['HIND']
  w.winw = row['WINW']
  w.winn = row['WINN']
  w.wind = row['WIND']
  w.dinw = row['DINW']
  w.dinn = row['DINN']
  w.dind = row['DIND']
  w.numerator = row['Numerator']
  w.denominator = row['Denominator']
  w.set = row['Set']
  w.base_net_amount = row['BaseNetAmount']
  w.base_purchase_price = row['BasePurchasePrice']
  w.retail_value = row['RetailValue']
  w.category = row['Category']
  w.image = row['Image']
  w.framed = row['Framed']
  w.frame_condition = row['FrameCondition']
  w.current_owner = row['CurrentOwner'] # 0 = no current owner, anything else is contact_id
  if row['SoldTo'] != "-1"
    w.contact = Contact.find(row['SoldTo'])
  end
  w.sold = if (row['SalesDate'].nil? || row['SalesDate'].empty?) then false else true end# if it's null it means it hasn't sold, 0 = not sold, 1 = sold
  w.erdman = if row['Status'] == "0" then true else false end # 1 = not in erdman art, 0 = in erdman art
  w.location = row['Location'] # location has contact id
  w.corporate_collection = if row['Location'] == '2169' then true else false end
  w.bin = row['BinNumber']
  w.save
end


