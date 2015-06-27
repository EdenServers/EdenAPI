FactoryGirl.define do
  factory :image do
    name "Minecraft"
    description "Minecraft Server"
    repo "dernise/minecraft"

    trait :wrong_repo do
      repo "derniseses/minedsfsd"
    end

    factory :image_with_container do
      after(:create) do |image|
        image.create_docker_image
        create(:container, image: image)
      end
    end

    factory :image_wrong_repo, traits: [:wrong_repo]
  end
end