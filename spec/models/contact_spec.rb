describe Contact, :type => :model do

  describe '#getName' do
    it 'returns full name if it exists' do
      test_contact = create(:contact, first_name: 'Testy', last_name: 'McTest')
      result = test_contact.getName()
      expect(result).to eq 'Testy McTest'
    end

    it 'returns only first name if the only option' do
      test_contact = create(:contact, first_name: 'Miranda')
      result = test_contact.getName()
      expect(result).to eq 'Miranda'
    end

    it 'returns only the last name if the only option' do
      test_contact = create(:contact, last_name: 'Hughes')
      result = test_contact.getName()
      expect(result).to eq 'Hughes'
    end

    it 'returns institution if no name' do
      test_contact = create(:contact, institution: 'The Cool Place')
      result = test_contact.getName()
      expect(result).to eq 'The Cool Place'
    end

    it 'returns empty string if no info' do
      test_contact = create(:contact)
      result = test_contact.getName()
      expect(result).to eq ''
    end
  end

  describe '#getAddress' do
    it 'returns the address if it exists' do
      test_contact = create(:contact)
      result = test_contact.getAddress()
      expect(result).to eq ''
    end

    it 'returns the address1 if only one' do
      test_contact = create(:contact, address1: '3958 Bland St')
      result = test_contact.getAddress()
      expect(result).to eq '3958 Bland St'
    end

    it 'returns the address2 if exists' do
      test_contact = create(:contact, address1: '3958 Bland St', address2: 'Apt 38')
      result = test_contact.getAddress()
      expect(result).to eq '3958 Bland St Apt 38'
    end

    it 'returns the city if it exists' do
      test_contact = create(:contact, city: 'New Cityshire')
      result = test_contact.getAddress()
      expect(result).to eq 'New Cityshire'
    end

    it 'returns the city and state if exists' do
      test_contact = create(:contact, city: 'Orangeville', state_prov: 'IL')
      result = test_contact.getAddress()
      expect(result).to eq 'Orangeville, IL'
    end

    it 'returns the state if only one' do
      test_contact = create(:contact, state_prov: 'MN')
      result = test_contact.getAddress()
      expect(result).to eq 'MN'
    end

    it 'returns postal code if only one' do
      test_contact = create(:contact, postal_code: '02849')
      result = test_contact.getAddress()
      expect(result).to eq '02849'
    end

    it 'returns state and postal code if only ones' do
      test_contact = create(:contact, state_prov: 'ON', postal_code: '39V 3UT')
      result = test_contact.getAddress()
      expect(result).to eq 'ON 39V 3UT'
    end

    it 'returns city state and postal code of only ones' do
      test_contact = create(:contact, city: 'HelloThere', state_prov: 'WI', postal_code: '04894')
      result = test_contact.getAddress()
      expect(result).to eq 'HelloThere, WI 04894'
    end

    it 'returns full address if exists' do
      test_contact = create(:contact, address1: '2 Village Blvd', address2: 'Floor 3', city: 'Hollardish', state_prov: 'OW', postal_code: 'T3V 2V4')
      result = test_contact.getAddress()
      expect(result).to eq "2 Village Blvd Floor 3\n\nHollardish, OW T3V 2V4"
    end

    it 'returns address and state' do
      test_contact = create(:contact, address1: '3958 Bland St', state_prov: 'ID')
      result = test_contact.getAddress()
      expect(result).to eq "3958 Bland St\n\nID"
    end
  end

  describe '#getInfo' do
    it 'returns nothing if all empty' do
      test_contact = create(:contact)
      result = test_contact.getInfo()
      expect(result).to eq ''
    end

    it 'returns institution and address' do
      test_contact = create(:contact, institution: 'Awesome Stuff', city: 'Langerd', state_prov: 'IV')
      result = test_contact.getInfo()
      expect(result).to eq "Awesome Stuff\n\nLangerd, IV"
    end

    it 'returns institution and city' do
      test_contact = create(:contact, institution: 'Hi Friends', city: 'Northwersh')
      result = test_contact.getInfo()
      expect(result).to eq "Hi Friends\n\nNorthwersh"
    end

    it 'returns institution and state' do
      test_contact = create(:contact, institution: 'Cool Beans', state_prov: 'HI')
      result = test_contact.getInfo()
      expect(result).to eq "Cool Beans\n\nHI"
    end

    it 'returns city and state and name' do
      test_contact = create(:contact, first_name: 'Miho', last_name: 'Nothad', city: 'Noher', state_prov: 'OH')
      result = test_contact.getInfo()
      expect(result).to eq "Miho Nothad\n\nNoher, OH"
    end

    it 'returns only city and state if only ones' do
      test_contact = create(:contact, city: 'Langerd', state_prov: 'IV')
      result = test_contact.getInfo()
      expect(result).to eq "Langerd, IV"
    end

    it 'returns first and last name if no institution' do
      test_contact = create(:contact, first_name: 'Howard', last_name: 'Wirsh')
      result = test_contact.getInfo()
      expect(result).to eq "Howard Wirsh"
    end
  end
end