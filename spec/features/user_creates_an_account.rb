feature 'User creates an account' do
  scenario 'they go to the sign up page' do
    visit new_user_path

    fill_in 'Email', with: 'testing@test.com'
    fill_in 'First name', with: 'Testy'
    fill_in 'Last name', with: 'McTesterson'
    fill_in 'Password', with: 'testpassword'
    fill_in 'Password confirmation', with: 'testpassword'
    click_button 'Create User'

    expect(page).to have_text 'Your Profile'
  end
end