FactoryGirl.define do
  factory :image_minecraft do
    name "Minecraft"
    description "Minecraft Server"
    repo "dernise/minecraft"
  end

  factory :image_wrong_repo do
    name "Error"
    repo "derniseses/minedsfsd"
  end
end