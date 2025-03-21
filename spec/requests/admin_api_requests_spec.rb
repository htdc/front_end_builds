describe 'The API for the admin section should work', type: :request do
  it 'should load the admin' do
    get '/frontend-config'
    expect(response).to have_http_status :success
    expect(response.body).to match('<title>Admin</title>')
  end

  it "should respond to the admin's API requests" do
    get '/frontend-config/api/host_apps/current.json'
    expect(response).to have_http_status :success
    expect(json['host_app']['name']).to eq('Dummy')
  end
end
