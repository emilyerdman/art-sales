describe Work, :type => :model do

  describe '#getArtist' do
    it 'returns the artist name if it exists' do
      work = Work.new(artist: Artist.new(first_name: "Test", last_name: "Testy", dates: '1991-'))
      result = work.getArtist()
      expect(result).to eq 'Test Testy'
    end

    it 'returns unknown if no artist exists' do
      work = Work.new()
      result = work.getArtist()
      expect(result).to eq 'UNKNOWN'
    end
  end

  describe '#getDimensions' do
    it 'returns nothing if no dimensions exist' do
      work = Work.new()
      result = work.getDimensions()
      expect(result).to be_empty
    end

    it 'returns just width/height if they exist' do
      work = Work.new(hinw: '1', winw: '2')
      result = work.getDimensions()
      expect(result).to eq '1 x 2 inches'
    end

    it 'returns just width/height/depth if they exist' do
      work = Work.new(hinw: '1', winw: '2', dinw: '3')
      result = work.getDimensions()
      expect(result).to eq '1 x 2 x 3 inches'
    end

    it 'returns just hxwxd with num/denom on h if they exist' do
      work = Work.new(hinw: '1', winw: '2', dinw: '3', hinn: '4', hind: '5')
      result = work.getDimensions()
      expect(result).to eq '1 4/5 x 2 x 3 inches'
    end

    it 'returns all if they all exist' do
      work = Work.new(hinw: '1', winw: '2', dinw: '3', hinn: '4', hind: '5', winn: '6', wind: '7', dinn: '8', dind: '9')
      result = work.getDimensions()
      expect(result).to eq '1 4/5 x 2 6/7 x 3 8/9 inches'
    end

    it "doesn't return partial num/denom pairs" do
      work = Work.new(hinw: '1', winw: '2', dinw: '3', hinn: '4', winn: '6', dind: '9')
      result = work.getDimensions()
      expect(result).to eq '1 x 2 x 3 inches'
    end
  end

  describe '#getCategory' do
    it 'returns a nonempty category' do
      work = Work.new(category: 'category1 * category2')
      result = work.getCategory()
      expect(result).to eq 'category1 * category2'
    end

    it "doesn't return a nonword category" do
      work = Work.new(category: '*')
      result = work.getCategory()
      expect(result).to be_empty
    end

    it 'returns empty for empty categorie' do
      work = Work.new()
      result = work.getCategory()
      expect(result).to be_empty
    end
  end

  describe '#getEdition' do
    it 'returns all if they all exist' do
      work = Work.new(numerator: '1', denominator: '2', set: 'AD')
      result = work.getEdition()
      expect(result).to eq 'Edition 1 of 2 AD'
    end

    it 'returns just set if it exists' do
      work = Work.new(set: 'ED')
      result = work.getEdition()
      expect(result).to eq 'ED'
    end

    it "doesn't return a partial edition" do
      work = Work.new(set: 'ED', numerator: '1')
      result = work.getEdition()
      expect(result).to eq 'ED'
    end

    it "returns nothing for blank work" do
      work = Work.new()
      result = work.getEdition()
      expect(result).to be_empty
    end
  end

  describe '#getImageUrl' do
    it 'returns the notfound image for empty images' do
      work = Work.new()
      result = work.getImageUrl()
      expect(result).to eq 'https://s3.us-east-2.amazonaws.com/works-images/notfound.png'
    end

    it 'returns the correct url for an image' do
      work = Work.new(image:  'I:\Image\johnson out on a limb].JPG')
      result = work.getImageUrl()
      expect(result).to eq 'https://s3.us-east-2.amazonaws.com/works-images/image/johnson out on a limb.jpg'
    end
  end

  describe '#getFrame' do
    it 'returns not framed for empty work' do
      work = Work.new()
      result = work.getFrame()
      expect(result).to eq 'Not Framed'
    end

    it 'returns not framed for not framed work' do
      work = Work.new(framed: false, frame_condition: 'test')
      result = work.getFrame()
      expect(result).to eq 'Not Framed'
    end

    it 'returns framed if exists but no details' do
      work = Work.new(framed: true)
      result = work.getFrame()
      expect(result).to eq 'Yes'
    end

    it 'returns frame details if they exist' do
      work = Work.new(framed: true, frame_condition: '12 MAPLE')
      result = work.getFrame()
      expect(result).to eq 'Yes - MAPLE'
    end

    it 'returns frame details if they exist with no number' do
      work = Work.new(framed: true, frame_condition: 'BIRCH')
      result = work.getFrame()
      expect(result).to eq 'Yes - BIRCH'
    end
  end

  describe '#getRetailValue' do
    it 'returns unknown for blank value' do
      work = Work.new()
      result = work.getRetailValue()
      expect(result).to eq 'Unknown'
    end

    it 'returns unknown for empty value' do
      work = Work.new(retail_value: '0.0')
      result = work.getRetailValue()
      expect(result).to eq 'Unknown'
    end

    it 'formats and returns nonempty value' do
      work = Work.new(retail_value: '230')
      result = work.getRetailValue()
      expect(result).to eq '$230.00'
    end
  end

  describe '#getOwner' do
    it 'returns nothing if no owner exists' do
      contact = create(:contact, id: 2518)
      work = Work.new()
      result = work.getOwner()
      expect(result).to be_nil
    end

    it 'finds the owner if listed as current_owner' do
      contact = Contact.new(id: 5)
      contact.save
      work = Work.new(current_owner: 5)
      result = work.getOwner()
      expect(result).to eq contact
    end

    it 'finds the owner if listed as contact_id' do
      contact = Contact.new(id: 23)
      contact.save
      work = Work.new(contact_id: 23)
      result = work.getOwner()
      expect(result).to eq contact
    end

    it 'returns erdman art group if current_owner is -1' do
      contact = create(:contact, id: 2518)
      work = Work.new(contact_id: -1, sold: false, erdman: true)
      result = work.getOwner
      expect(result.id).to eq 2518
    end
  end

  describe '#getDisplayInfo' do
    it 'returns correct display info for test work' do
      work = Work.new(title: 'MY TEST PIECE', full_year: '1988', media: 'WOOD', hinw: '1', winw: '2', dinw: '3', hinn: '4', hind: '5', 
        winn: '6', wind: '7', dinn: '8', dind: '9', numerator: '1', denominator: '2', set: 'AD')
      result = work.getDisplayInfo()
      expect(result).to eq "MY TEST PIECE, 1988\n\nWOOD\n\n1 4/5 x 2 6/7 x 3 8/9 inches\n\nEdition 1 of 2 AD"
    end

    it 'returns correct display info for piece with no year and no edition' do
      work = Work.new(title: 'MY TEST PIECE', media: 'WOOD', hinw: '1', winw: '2', dinw: '3', hinn: '4', hind: '5', 
        winn: '6', wind: '7', dinn: '8', dind: '9')
      result = work.getDisplayInfo()
      expect(result).to eq "MY TEST PIECE\n\nWOOD\n\n1 4/5 x 2 6/7 x 3 8/9 inches"
    end

    it 'returns correct display info for min piece info' do
      work = Work.new(title: 'MY TEST PIECE', media: 'WOOD', hinw: '1', winw: '2')
      result = work.getDisplayInfo()
      expect(result).to eq "MY TEST PIECE\n\nWOOD\n\n1 x 2 inches"
    end
  end

  describe '#getAvailability' do
    it 'returns yes for eag_confirmed' do
      work = Work.new(eag_confirmed: true)
      result = work.getAvailability()
      expect(result).to eq 'Yes'
    end

    it 'returns no for sold piece' do
      contact = Contact.new(first_name: 'Test', last_name: 'McTest', id: 2)
      contact.save
      work = Work.new(current_owner: 2)
      result = work.getAvailability()
      expect(result).to eq 'No - Sold To Test McTest'
    end

    it 'returns possibly for unknown location' do
      work = Work.new()
      result = work.getAvailability()
      expect(result).to eq 'Possibly'
    end
  end

  describe '#getLocation' do

    it 'returns EAG if confirmed' do
      work = Work.new(eag_confirmed:true, bin: '12B')
      result = work.getLocation()
      expect(result).to eq "Erdman Art Group\n\nBin 12B"
    end

    it 'returns contact if it exists' do
      contact = Contact.new(institution: 'Test Place', id: 20)
      contact.save
      work = Work.new(location: 20)
      result = work.getLocation()
      expect(result).to eq "Last Known - Test Place"
    end

    it 'returns contact name if it exists' do
      contact = Contact.new(first_name: 'Test', last_name: 'McTest', id: 20)
      contact.save
      work = Work.new(location: 20)
      result = work.getLocation()
      expect(result).to eq "Last Known - Test McTest"
    end

    it 'returns unknown if no contacts exists' do
      work = Work.new(location: '')
      result = work.getLocation()
      expect(result).to eq "Unknown"
    end
  end

  describe '#isCorporateCollection' do

    it 'returns true if corporate collection location is right' do
      work = Work.new(location: '2169')
      result = work.isCorporateCollection()
      expect(result).to be true
    end

    it 'returns false is not corp collection' do
      work = Work.new(location: '1')
      result = work.isCorporateCollection()
      expect(result).to be false
    end
  end

  describe '#getPostersWorks' do
    it 'only shows available posters' do
      posters = create_list(:work, 10, art_type: 'POSTER', sold: false, current_owner: '0')
      posters_sold = create_list(:work, 3, art_type: 'POSTER', sold: true, current_owner: '23')
      works = Work.getPostersWorks()
      expect(works.size).to be 10
    end
  end

  describe '#getNonCorpWorks(inc_retail_filter)' do
    it 'shows only available posters' do
      posters = create_list(:work, 10, art_type: 'POSTER', sold: false, current_owner: '0')
      posters_sold = create_list(:work, 3, art_type: 'POSTER', sold: true, current_owner: '23')
      works = Work.getNonCorpWorks(false)
      expect(works.size).to be 10
    end

    it 'shows only available non corp works' do
      non_corp = create_list(:work, 23, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: false)
      non_corp_sold = create_list(:work, 3, art_type: 'FINE ART', sold: true, current_owner: '23', eag_confirmed: false, corporate_collection: false)
      works = Work.getNonCorpWorks(false)
      expect(works.size).to be 23
    end

    it 'shows only non corp works' do
      non_corp = create_list(:work, 4, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: false)
      corp = create_list(:work, 9, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: true)
      works = Work.getNonCorpWorks(false)
      expect(works.size).to be 4 
    end

    it 'filters out by retail_value' do
      non_corp = create_list(:work, 4, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: false, retail_value: 30.00)
      corp = create_list(:work, 9, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: false, retail_value: 500.00)
      works = Work.getNonCorpWorks(true)
      expect(works.size).to be 4 
    end    
  end

  describe '#getCorpWorks()' do
    it 'shows only available corp coll + posters + non_corp' do
      posters = create_list(:work, 10, art_type: 'POSTER', sold: false, current_owner: '0')
      non_corp = create_list(:work, 2, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: false)
      corp = create_list(:work, 8, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: true)
      corp_sold = create_list(:work, 13, art_type: 'FINE ART', sold: true, current_owner: '23', eag_confirmed: false, corporate_collection: true)
      works = Work.getCorpWorks()
      expect(works.size).to be 20
    end
  end  

  describe '#filterByArtType(works, art_type)' do
    it 'shows only posters' do
      posters = create_list(:work, 4, art_type: 'POSTER')
      non_posters = create_list(:work, 20, art_type: 'FINE ART')
      works = Work.filterByArtType(Work.all, 'POSTER')
      expect(works.size).to be 4
    end

    it 'shows only fine art' do
      posters = create_list(:work, 4, art_type: 'POSTER')
      non_posters = create_list(:work, 20, art_type: 'FINE ART')
      works = Work.filterByArtType(Work.all, 'FINE ART')
      expect(works.size).to be 20
    end      
  end

  describe '#filterByAvailability(works, availability)' do
    it 'only shows available' do
      posters = create_list(:work, 10, art_type: 'POSTER', sold: false, current_owner: '0')
      posters_sold = create_list(:work, 3, art_type: 'POSTER', sold: true, current_owner: '43')
      non_corp = create_list(:work, 2, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: false)
      non_corp_sold = create_list(:work, 5, art_type: 'FINE ART', sold: true, eag_confirmed: false, corporate_collection: false)
      corp = create_list(:work, 8, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: true)
      corp_sold = create_list(:work, 13, art_type: 'FINE ART', sold: true, current_owner: '23', eag_confirmed: false, corporate_collection: true)
      works = Work.filterByAvailability(Work.all, '1')
      expect(works.size).to be 20
    end

    it 'only shows unavailable' do
      posters = create_list(:work, 10, art_type: 'POSTER', sold: false, current_owner: '0')
      posters_sold = create_list(:work, 3, art_type: 'POSTER', sold: true, current_owner: '43')
      non_corp = create_list(:work, 2, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: false)
      non_corp_sold = create_list(:work, 5, art_type: 'FINE ART', sold: true, eag_confirmed: false, corporate_collection: false)
      corp = create_list(:work, 8, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: true)
      corp_sold = create_list(:work, 13, art_type: 'FINE ART', sold: true, current_owner: '23', eag_confirmed: false, corporate_collection: true)
      works = Work.filterByAvailability(Work.all, '0')
      expect(works.size).to be 21
    end
  end

  describe '#filterByFramed(works, framed)' do
    it 'only shows framed' do
      framed = create_list(:work, 9, framed: true)
      not_framed = create_list(:work, 2, framed: false)
      works = Work.filterByFramed(Work.all, '1')
      expect(works.size).to be 9
    end

    it 'only shows not framed' do
      framed = create_list(:work, 9, framed: true)
      not_framed = create_list(:work, 2, framed: false)
      works = Work.filterByFramed(Work.all, '0')
      expect(works.size).to be 2
    end
  end

  describe '#filterByCollection' do
    it 'only shows corp works' do
      corp = create_list(:work, 6, corporate_collection: true)
      non_corp = create_list(:work, 9, corporate_collection: false)
      works = Work.filterByCollection(Work.all, '1')
      expect(works.size).to be 6
    end

    it 'only shows non corp works' do 
      corp = create_list(:work, 6, corporate_collection: true)
      non_corp = create_list(:work, 9, corporate_collection: false)
      works = Work.filterByCollection(Work.all, '0')
      expect(works.size).to be 9
    end      
  end

  describe '#searchWorks(work, keywork)' do
    it 'finds by title' do
      bunnies = create_list(:work, 3, title: 'BUNNIES HUZZAH')
      not_bunnies = create_list(:work, 2, title: 'SOMETHING ELSE')
      works = Work.searchWorks(Work.all, 'bunnies')
      expect(works.size).to be 3
    end

    it 'finds by category' do
      bunnies = create_list(:work, 8, category: '•LANDSCAPE•BUNNIES•')
      not_bunnies = create_list(:work, 3, category: '•LANDSCAPE•')
      works = Work.searchWorks(Work.all, 'bunnies')
      expect(works.size).to be 8
    end

    it 'finds by media' do
      bunnies = create_list(:work, 6, media: 'MADE BY BUNNIES')
      not_bunnies = create_list(:work, 2, media: 'MADE BY BUNBUNS')
      works = Work.searchWorks(Work.all, 'bunnies')
      expect(works.size).to be 6
    end

    it 'finds by inventory_number' do
      works = create_list(:work, 10)
      work = create(:work, inventory_number: 'A-99999')
      works = Work.searchWorks(Work.all, '99999')
      expect(works.size).to be 1
    end
  end

  describe '#filterByCategory(works, categories, operator)' do
    it 'filters by one category' do
      bunnies = create_list(:work, 3, category: '•LANDSCAPE•BUNNIES•')
      not_bunnies = create_list(:work, 5, category: '•LANDSCAPE•BEAUTY•')
      works = Work.filterByCategory(Work.all, ['BUNNIES'], 'OR')
      expect(works.size).to be 3
    end

    it 'filters by two categories with OR' do
      bunnies = create_list(:work, 3, category: '•LANDSCAPE•BUNNIES•')
      not_bunnies = create_list(:work, 5, category: '•LANDSCAPE•BEAUTY•')
      not_either = create_list(:work, 10, category: '')
      works = Work.filterByCategory(Work.all, ['BUNNIES', 'BEAUTY'], 'OR')
      expect(works.size).to be 8
    end  

    it 'filters by two categories with AND' do
      bunnies = create_list(:work, 3, category: '•LANDSCAPE•BUNNIES•')
      not_bunnies = create_list(:work, 5, category: '•LANDSCAPE•BEAUTY•')
      not_either = create_list(:work, 10, category: '')
      works = Work.filterByCategory(Work.all, ['LANDSCAPE', 'BEAUTY'], 'AND')
      expect(works.size).to be 5
    end    

    it 'returns zero if non match' do
      bunnies = create_list(:work, 3, category: '•LANDSCAPE•BUNNIES•')
      not_bunnies = create_list(:work, 5, category: '•LANDSCAPE•BEAUTY•')
      not_either = create_list(:work, 10, category: '')
      works = Work.filterByCategory(Work.all, ['LANDSCAPE', 'LOVE'], 'AND')
      expect(works.size).to be 0
    end       
  end

  describe '#filterUnique(works)' do
    it 'filters out duplicates' do
      artists = create_list(:artist, 10)
      dups = create_list(:work, 5, title: 'SAME', artist_id: 10)
      not_dups = create_list(:not_dups, 5)
      works = Work.filterUnique(Work.all)
      expect(works.size).to be 6
    end

# the problem is that it starts creating new artists where the last one stopped
    it 'returns all if no dups' do
      %w(11, 12, 13, 14, 15).map do |i|
        create(:artist, id: i)
      end
      not_dups = create_list(:not_dups, 5)
      works = Work.filterUnique(Work.all)
      expect(works.size).to be 5
    end
  end

  describe '#sortWorks(works, sort_type' do
    it 'sorts by inventory_number ascending' do
      one = create(:work, inventory_number: 'A-00283')
      two = create(:work, inventory_number: 'A-01029')
      three = create(:work, inventory_number: 'A-00001')
      works = Work.sortWorks(Work.all, 0)
      expect(works).to eq [three, one, two]
    end

    it 'sorts by inventory_number descending' do
      one = create(:work, inventory_number: 'A-00283')
      two = create(:work, inventory_number: 'A-01029')
      three = create(:work, inventory_number: 'A-00001')
      works = Work.sortWorks(Work.all, 1)
      expect(works).to eq [two, one, three]
    end  

    it 'sorts by title desc' do
      one = create(:work, title: 'Hello There')
      two = create(:work, title: 'Spanish Dance')
      three = create(:work, title: 'Aardvark Array')
      works = Work.sortWorks(Work.all, 2)
      expect(works).to eq [two, one, three]
    end 

    it 'sorts by title asc' do
      one = create(:work, title: 'Hello There')
      two = create(:work, title: 'Spanish Dance')
      three = create(:work, title: 'Aardvark Array')
      works = Work.sortWorks(Work.all, 3)
      expect(works).to eq [three, one, two]
    end 

    it 'sorts by retail_value desc' do
      one = create(:work, retail_value: 25.39)
      two = create(:work, retail_value: 25.40)
      three = create(:work, retail_value: 1000.00)
      four = create(:work, retail_value: nil)
      works = Work.sortWorks(Work.all, 4)
      expect(works).to eq [three, two, one]
    end    


    it 'sorts by retail_value asc' do
      one = create(:work, retail_value: 25.39)
      two = create(:work, retail_value: 25.40)
      three = create(:work, retail_value: 1000.00)
      four = create(:work, retail_value: nil)
      works = Work.sortWorks(Work.all, 5)
      expect(works).to eq [one, two, three]
    end 
  end
end

