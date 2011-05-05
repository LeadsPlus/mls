counties = %w[Louth Dublin Kerry Waterford Wicklow Antrim Fermanagh Armagh Carlow Cavan Clare Cork Derry Donegal
                Down Galway Kildare Kilkenny Laois Letrim Limerick Longford Mayo Monaghan Offaly Roscommon Sligo
                Tipperary Tyrone Westmeath Wexford].freeze

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

Factory.define House do |house|
  house.title "This is the title of a house"
  house.description Faker::Lorem.paragraph()
  house.image_url images[rand(images.size)]

  house.number 1+rand(100)
  house.street Faker::Address.street_address()
  house.town Faker::Address.city
  house.county_id 4

  house.price (150 + rand(350))*1000
  house.bedrooms 1+rand(5)
end

Factory.define Search do |search|
  search.deposit 40_000
  search.min_payment 700
  search.max_payment 1000
  search.county_id 4
  search.term 30
end