feature 'User logs in and searches for a piece' do
  scenario 'they go to the sign up page' do
    visit login_path

    fill_in 'Email', with: 'testing@test.com'
    fill_in 'Password', with: 'testpassword'
    fill_in 'Password confirmation', with: 'testpassword'
    click_button 'Create User'

    expect(page).to have_text 'Your Profile'
  end
end