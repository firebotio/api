include ActionDispatch::TestProcess

FactoryGirl.define do
  def fixtures_path(path)
    Rails.root.join("spec/fixtures").join(path).to_s
  end

  sequence(:email) { |n| "email-#{n}@example.com" }
  sequence(:name)  { |n| "name-#{n}" }
  sequence(:uid)   { |n| "uid-#{n}" }
end
