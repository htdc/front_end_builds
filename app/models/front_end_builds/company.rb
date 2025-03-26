module FrontEndBuilds
  class Company < ActiveRecord::Base
    belongs_to :app, class_name: "FrontEndBuilds::App"
  end
end
