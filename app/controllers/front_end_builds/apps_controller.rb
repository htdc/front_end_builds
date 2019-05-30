require_dependency "front_end_builds/application_controller"

module FrontEndBuilds
  class AppsController < ApplicationController
    before_action :set_app , :only => [:show, :destroy, :update]

    def index
      apps = App.includes(:recent_builds, :live_build)

      recent_builds = apps.map(&:recent_builds)
      live_builds = apps.map(&:live_build)
      builds = recent_builds
               .push(live_builds)
               .flat_map(&:to_a)
               .compact
               .uniq

      respond_with_json(
        apps: apps.map(&:serialize),
        builds: builds.map(&:serialize)
      )
    end

    def show
      respond_with_json({
        app: @app.serialize,
        builds: @app.recent_builds.map(&:serialize)
      })
    end

    def create
      @app = FrontEndBuilds::App.new( app_create_params )

      if @app.save
        respond_with_json(
          { app: @app.serialize },
          location: nil
        )
      else
        respond_with_json(
          { errors: @app.errors },
          status: :unprocessable_entity
        )
      end
    end

    def update
      if @app.update_attributes( app_update_params )

        respond_with_json(
          { app: @app.serialize },
          location: nil
        )
      else
        respond_with_json(
          { errors: @app.errors },
          status: :unprocessable_entity
        )
      end
    end

    def destroy
      if @app.destroy
        respond_with_json(
          { app: { id: @app.id } },
          location: nil
        )
      else
        respond_with_json(
          { errors: @app.errors },
          status: :unprocessable_entity
        )
      end
    end

    private

    def set_app
      @app = FrontEndBuilds::App.find(params[:id])
    end

    def app_create_params
      params.require(:app).permit(
        :name
      )
    end

    def app_update_params
      params.require(:app).permit(
        :name,
        :require_manual_activation,
        :live_build_id
      )
    end
  end
end
