require 'rails_helper'

module FrontEndBuilds
  RSpec.describe AppsController, :type => :controller do
    routes { FrontEndBuilds::Engine.routes }

    let(:app) { create(:front_end_builds_app, name: 'dummy') }
    let!(:builds) { create_list(:front_end_builds_build, 2, app: app) }
    let!(:live_build) { create(:front_end_builds_build, :live, :fetched, app: app) }

    describe 'index' do
      it "should find all apps" do
        get :index, format: :json

        expect(response.successful?).to be true
        expect(json['apps'].length).to eq(1)
        expect(json['builds'].length).to eq(3)
      end
    end

    describe "many builds" do
      let(:many_build_app) { create(:front_end_builds_app, name: 'many builds') }
      let!(:live_build) { create(:front_end_builds_build, :live, :fetched, app: many_build_app)}
      let!(:many_builds) { create_list(:front_end_builds_build, 100, app: many_build_app) }

      it "should include the live build even it's not most recent" do
        get :index, format: :json

        expect(json['builds'].map { | a | a['id'] }).to include(live_build.id)
      end
    end

    describe 'show' do
      it "should find the requested app" do
        get :show, params: { id: app.id }, format: :json

        expect(response.successful?).to be true
        expect(json['app']['id']).to eq(app.id)
        expect(json['builds'].length).to eq(3)
        expect(json['app']['live_build_id']).to eq(app.live_build.id)
      end
    end

    describe 'create' do
      it "should create a new app" do
        post :create, params: {
            app: {
              name: 'my-new-app'
            }
          },
          format: :json

        expect(response.successful?).to be true

        app = FrontEndBuilds::App.where(name: 'my-new-app').limit(1).first
        expect(json['app']['id']).to eq(app.id)
      end
    end

    describe 'update' do
      let(:app) { create :front_end_builds_app, name: 'forsaken' }
      let!(:live_build) { create :front_end_builds_build, :live, :fetched, app: app }
      let!(:new_build) { create :front_end_builds_build, :fetched, app: app }
      let(:prohibited_build) { create(:front_end_builds_build, :fetched, app: app, branch: 'experimental')}

      it "should edit an existing app" do
        post :update,
          params: {
            id: app.id,
            app: {
              live_build_id: new_build.id
            }
          },
          format: :json

        expect(response.successful?).to be true

        app.reload

        expect(app.live_build).to eq(new_build)
        expect(json['app']['id']).to eq(app.id)
      end

      it 'should fail when branch restrictions are triggered' do
        allow(ENV).to receive(:[]).with("FRONT_END_BUILDS_RESTRICT_DEPLOYS").and_return("TRUE")
        allow(ENV).to receive(:[]).with("FRONT_END_BUILDS_PRODUCTION_BRANCH").and_return("production")

        post :update,
          params: {
            id: app.id,
            app: {
              live_build_id: prohibited_build.id
            }
          },
          format: :json

        body = JSON.parse(response.body)
        expect(response.status).to be(422)
        expect(body["errors"]["validations"].first).to eq("Cannot activate build - build is from branch: experimental, but deploys are restricted to branch: production")
      end
    end

    describe 'destroy' do
      let(:deletable_app) { create :front_end_builds_app, name: 'forsaken' }

      context 'a valid app' do
        before(:each) do
          post :destroy,
            params: {
              id: deletable_app.id
            },
            format: :json
        end

        context 'the response' do
          subject { response }
          it { expect(subject.successful?).to be true }
        end

        context 'the data' do
          subject { json['app']['id'] }
          it { expect(subject).not_to be nil }
        end

        context 'the record' do
          subject { FrontEndBuilds::App.where(id: deletable_app.id).first }
          it { should be_nil }
        end
      end
    end
  end
end
