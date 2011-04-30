namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    require 'faker'
    make_default_search
    make_houses
  end
end

def make_default_search
  Search.create :payment => 1100, :deposit => 40000
end

def make_houses
  100.times do |i|
    address = "#{Faker::Address.street_address}, #{Faker::Address.city}"
    beds = rand(4) + 1
    price = (150 + rand(350))*1000
    House.create(:address => address, :bedrooms => beds, :price => price)
  end
end