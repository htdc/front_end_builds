require 'rails_helper'

describe "Front end builds new version", type: :request do
  let(:front_end_app) { FactoryBot.create :front_end_builds_app, name: "dummy" }
  let(:version_url) { "/front_end_builds/best.json?app_name=dummy&branch=master" }
  let(:endpoint) { "http://www.ted.com/builds/1" }

  before(:each) do
    FactoryBot.create(
      :front_end_builds_build,
      :fetched,
      app: front_end_app,
    )

    FactoryBot.create(:front_end_builds_pubkey, :fixture_pubkey)

    stub_request(:get, endpoint)
      .to_return(body: 'your app!')
  end

  it "gets a different version when a new build is created" do
    # get the current version
    get version_url
    expect(response).to have_http_status :success
    expect(json['version']).to_not be_nil

    original_version = json['version']

    post "/dummy", params: {
      branch: "master",
      sha: "a1b2c3",
      job: "jenkins-build-1",
      endpoint: endpoint,
      signature: create_signature("dummy-#{endpoint}")
    }

    expect(response).to have_http_status :success

    # now we should get a new version
    get version_url
    expect(response).to have_http_status :success
    expect(json['version']).to_not be_nil

    new_version = json['version']

    expect(new_version).to be > original_version
  end
end
