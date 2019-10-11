describe User do
  it "defaults to unapproved" do
    user = User.new()
    expect(user.approved).to eq false
  end

  it "defaults to posters category" do
    user = User.new()
    expect(user.category).to eq "posters"
  end
end

describe User, "#getAddressString" do
  it "prints the full address string" do
    user = User.new(address: {street_address: '123 Test St', city: 'Test', state: 'TS', zip: '12345', country: 'Test'}, email: 'test@test.com')
    result = user.getAddressString()
    expect(result).to eq("123 Test St\nTest, TS 12345\nTest")
  end
end

describe User, "#approve_user" do
  it "approves a user" do
    user = User.new()
    user.approve_user(true)
    expect(user.approved).to eq true
  end

  it "unapproves a user" do
    user = User.new(approved: true)
    user.approve_user(false)
    expect(user.approved).to eq false
  end
end

describe User, "#change_user_category" do
  it "changes the category to specified" do
    user = User.new()
    user.change_user_category('admin')
    expect(user.category).to eq "admin"
  end
end

describe User, "#generate_password_token" do
  it "creates a new token and a sent_at time" do
    user = User.new(email: 'test@test.com', password: 'password')
    timestamp = Time.now
    user.generate_password_token!
    token = user.reset_password_token
    sent_at = user.reset_password_sent_at
    expect(token).not_to be_empty
    expect(sent_at).to be >= timestamp
  end
end

describe User, "#password_token_valid" do
  it "verifies the token is valid" do
    user = User.new(email: 'test@test.com', password: 'password')
    before_method = user.reset_password_token
    user.generate_password_token!
    result = user.password_token_valid?
    expect(before_method).to be_nil
    expect(result).to be true
  end
end

describe User, '#reset_password' do
  it 'sets password_token to nil and saves new password' do
    user = User.new(email: 'test@test.com', password: 'password', reset_password_token: 'test')
    user.reset_password!('newpassword')
    expect(user.password).to eq 'newpassword'
    expect(user.reset_password_token).to be_nil
  end
end
