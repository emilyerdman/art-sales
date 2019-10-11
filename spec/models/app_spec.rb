describe App, '#approve' do 
  it 'makes an app approved' do
    app = App.new()

    initial = app.approved

    app.approve(true)
    result = app.approved
    app.approve(false)
    disapproved = app.approved

    expect(initial).to eq false
    expect(result).to eq true
    expect(disapproved).to eq false
  end
end

describe App do
  it "won't create an app without a user" do
    app = App.new(work: Work.new)
    expect(app).to be_invalid
  end

  it "won't create an app without a work" do
    app = App.new(user: User.new)
    expect(app).to be_invalid
  end
end