FactoryBot.define do
  factory :user do
    first_name { 'Alexis' }
    last_name { 'Parave' }
    email { 'alexis@mail.com' }
    password { '123456' }
    password_confirmation { '123456' }
    role { 'customer' }
  end
end
