describe "Works Views", type: :request do
  it "shows correct page when not logged in" do
    get works_path
    expect(response.body).to include "You must log in to view works"
  end

  it 'shows correct page when logged in but not approved' do
    user = create(:user, approved: false)
    # log in user
    get sessions_create_path, params: {'email' => user.email, 'password' => user.password }
    get works_path
    expect(response.body).to include "You must be approved by the admin to view works"
  end

  it 'shows all works when logged in and approved as admin' do
    posters = create_list(:work, 13, art_type: 'POSTER', sold: false, current_owner: '0')
    posters_sold = create_list(:work, 3, art_type: 'POSTER', sold: true, current_owner: '43')
    non_corp = create_list(:work, 2, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: false)
    non_corp_sold = create_list(:work, 5, art_type: 'FINE ART', sold: true, eag_confirmed: false, corporate_collection: false)
    corp = create_list(:work, 8, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: true)
    corp_sold = create_list(:work, 13, art_type: 'FINE ART', sold: true, current_owner: '23', eag_confirmed: false, corporate_collection: true)
    user = create(:user, approved: true, category: 3)
    get sessions_create_path, params: {'email' => user.email, 'password' => user.password }
    get works_path
    expect(response.body).to include "1 - 10 of 44"
  end

  it 'shows only posters when logged in as posters' do
    posters = create_list(:work, 13, art_type: 'POSTER', sold: false, current_owner: '0')
    posters_sold = create_list(:work, 3, art_type: 'POSTER', sold: true, current_owner: '43')
    non_corp = create_list(:work, 2, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: false)
    non_corp_sold = create_list(:work, 5, art_type: 'FINE ART', sold: true, eag_confirmed: false, corporate_collection: false)
    corp = create_list(:work, 8, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: true)
    corp_sold = create_list(:work, 13, art_type: 'FINE ART', sold: true, current_owner: '23', eag_confirmed: false, corporate_collection: true)
    user = create(:user, approved: true, category: 0)
    get sessions_create_path, params: {'email' => user.email, 'password' => user.password }
    get works_path
    expect(response.body).to include "1 - 10 of 13"
  end

  it 'shows posters and non corp for noncorp user' do
    posters = create_list(:work, 13, art_type: 'POSTER', sold: false, current_owner: '0')
    posters_sold = create_list(:work, 3, art_type: 'POSTER', sold: true, current_owner: '43')
    non_corp = create_list(:work, 2, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: false)
    non_corp_sold = create_list(:work, 5, art_type: 'FINE ART', sold: true, eag_confirmed: false, corporate_collection: false)
    corp = create_list(:work, 8, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: true)
    corp_sold = create_list(:work, 13, art_type: 'FINE ART', sold: true, current_owner: '23', eag_confirmed: false, corporate_collection: true)
    user = create(:user, approved: true, category: 1)
    get sessions_create_path, params: {'email' => user.email, 'password' => user.password }
    get works_path
    expect(response.body).to include "1 - 10 of 15"
  end

  it 'shows posters all fine art for corp user' do
    posters = create_list(:work, 13, art_type: 'POSTER', sold: false, current_owner: '0')
    posters_sold = create_list(:work, 3, art_type: 'POSTER', sold: true, current_owner: '43')
    non_corp = create_list(:work, 2, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: false)
    non_corp_sold = create_list(:work, 5, art_type: 'FINE ART', sold: true, eag_confirmed: false, corporate_collection: false)
    corp = create_list(:work, 8, art_type: 'FINE ART', sold: false, eag_confirmed: true, corporate_collection: true)
    corp_sold = create_list(:work, 13, art_type: 'FINE ART', sold: true, current_owner: '23', eag_confirmed: false, corporate_collection: true)
    user = create(:user, approved: true, category: 2)
    get sessions_create_path, params: {'email' => user.email, 'password' => user.password }
    get works_path
    expect(response.body).to include "1 - 10 of 23"
  end    
end
