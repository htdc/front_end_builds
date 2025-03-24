FactoryBot.define do
  factory :front_end_builds_company, :class => 'FrontEndBuilds::Company' do
    association :app, factory: :front_end_builds_app
    sequence(:name) { |n| "company-#{n}" }
    branch { "master" }
  end
end
