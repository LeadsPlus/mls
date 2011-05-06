namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    make_default_search
#    make_houses
  end
end

def make_default_search
  Search.create :max_payment => 1100, :min_payment => 800, :deposit => 50000, :term => 25, :county_id => 4
end

def make_houses
  images = ['http://mediacache-s3eu.daft.ie/MZYU1EHKU5Wezk5xuw07WPdRb8VZeof6esL9j1djM-RtPWRhZnQmZT0xNjB4MTIw.jpg',
            'http://mediacache-s3eu.daft.ie/wh2z6UZ1LyVzMwwJfMNjSXvixS89Qu5cQ0mDtPstW-htPWRhZnQmZT0xNjB4MTIw.jpg',
            'http://c2.dmstatic.com/i/daft_no_image_small.png',
            'http://mediacache-s3eu.daft.ie/9r1zwtCeM_TxtFGiTeBXr13Ua3Zhi572qAfWIR-VV5xtPWRhZnQmZT0xNjB4MTIw.jpg',
            'http://mediacache-s3eu.daft.ie/0W5I9vTLP8EorN7DQVWh2TwWZoOS2l7H1Jf9OoTrrfRtPWRhZnQmZT0xNjB4MTIw.jpg',
            'http://mediacache-s3eu.daft.ie/epOBx9OFmHUwTanFMTSQ4sc83llrBU6DhQhary6s4wptPWRhZnQmZT0xNjB4MTIw.jpg',
            'http://mediacache-s3eu.daft.ie/iB7TZ5jo3liVIiM0HM2ZEth6Jsih2pQqNHSQRe5Y40htPWRhZnQmZT0xNjB4MTIw.jpg',
            'http://mediacache-s3eu.daft.ie/xH3YKZikRfEQrHuuyzT4N_N0ibHGswBbdIhhTYb_2JttPWRhZnQmZT0xNjB4MTIw.jpg',
            'http://mediacache-s3eu.daft.ie/gXulIiAGyLP0iN0zHv-HxNftpfKnP4SuguHGxM5TJKptPWRhZnQmZT0xNjB4MTIw.jpg',
            'http://mediacache-s3eu.daft.ie/d93cCr8TQrjiRQ8WxCHFHK2NoHTEw0zVUaTOA8SYyqFtPWRhZnQmZT0xNjB4MTIw.jpg',
            ]

  1000.times do |i|
#    these functions should also be dried out with the factories
    beds = rand(4) + 1
    price = (150 + rand(350))*1000
    House.create(:street => Faker::Address.street_address,
                 :number => 1 + rand(30),
                 :town => Faker::Address.city,
                 :county_id => rand(31),
                 :bedrooms => beds,
                 :price => price,
                 :image_url => images[rand(images.size)],
                 :title => Faker::Lorem.sentence(),
                 :description => Faker::Lorem.paragraph)
  end
end