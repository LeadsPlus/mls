namespace :houses do
  desc "Change all the house daft_urls into daft_id's"
  task :convert_daft_urls => :environment do
    delay.convert_urls_to_ids
  end
end

def convert_urls_to_ids
  House.find_each(:batch_size => 2000) do |house|
    house.daft_url.match(/[0-9]+/) do |id|
      house.daft_id = id[0].to_i
      house.save!
    end
  end
end