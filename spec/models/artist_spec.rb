describe Artist, :type => :model do
  describe '#getName' do
    it 'returns correct name' do
      artist = create(:artist, first_name: 'Testy', last_name: 'McTest')
      result = artist.getName()
      expect(result).to eq 'Testy McTest'
    end
  end
end