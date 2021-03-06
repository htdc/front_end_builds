require 'rails_helper'

module FrontEndBuilds
  RSpec.describe AppsController, :type => :controller do
    routes { FrontEndBuilds::Engine.routes }

    let(:app) { FactoryGirl.create :front_end_builds_app, name: 'dummy' }
    let!(:builds) { FactoryGirl.create_list :front_end_builds_build, 2, app: app }
    let!(:live_build) { FactoryGirl.create :front_end_builds_build, :live, :fetched, app: app }

    describe 'index' do
      it "should find all apps" do
        get :index, format: :json

        expect(response).to be_success
        expect(json['apps'].length).to eq(1)
        expect(json['builds'].length).to eq(3)
      end
    end

    describe 'show' do
      it "should find the requested app" do
        get :show, id: app.id, format: :json

        expect(response).to be_success
        expect(json['app']['id']).to eq(app.id)
        expect(json['builds'].length).to eq(3)
        expect(json['app']['live_build_id']).to eq(app.live_build.id)
      end
    end

    describe 'create' do
      it "should create a new app" do
        post :create, app: {
            name: 'my-new-app'
          },
          format: :json

        expect(response).to be_success

        app = FrontEndBuilds::App.where(name: 'my-new-app').limit(1).first
        expect(json['app']['id']).to eq(app.id)
      end
    end

    describe 'update' do
      let(:app) { FactoryGirl.create :front_end_builds_app, name: 'forsaken' }
      let!(:live_build) { FactoryGirl.create :front_end_builds_build, :live, :fetched, app: app }
      let!(:new_build) { FactoryGirl.create :front_end_builds_build, :fetched, app: app }
      let(:prohibited_build) { FactoryGirl.create(:front_end_builds_build, :fetched, app: app, branch: 'experimental')}

      it "should edit an existing app" do
        post :update,
          id: app.id,
          app: {
            live_build_id: new_build.id
          },
          format: :json

        expect(response).to be_success

        app.reload

        expect(app.live_build).to eq(new_build)
        expect(json['app']['id']).to eq(app.id)
      end

      it 'should fail when branch restrictions are triggered' do
        allow(ENV).to receive(:[]).with("FRONT_END_BUILDS_RESTRICT_DEPLOYS").and_return("TRUE")
        allow(ENV).to receive(:[]).with("FRONT_END_BUILDS_PRODUCTION_BRANCH").and_return("production")

        post :update,
             id: app.id,
             app: {
               live_build_id: prohibited_build.id
             },
             format: :json

        body = JSON.parse(response.body)
        expect(response.status).to be(422)
        expect(body["errors"]["validations"].first).to eq("Cannot activate build - build is from branch: experimental, but deploys are restricted to branch: production")
      end
    end

    describe 'destroy' do
      let(:deletable_app) { FactoryGirl.create :front_end_builds_app, name: 'forsaken' }

      context 'a valid app' do
        before(:each) do
          post :destroy,
            id: deletable_app.id,
            format: :json
        end

        context 'the response' do
          subject { response }
          it { should be_success }
        end

        context 'the data' do
          subject { json['app']['id'] }
          it { should_not be_nil }
        end

        context 'the record' do
          subject { FrontEndBuilds::App.where(id: deletable_app.id).first }
          it { should be_nil }
        end
      end
    end
  end
end
