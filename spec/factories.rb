Factory.define House do |house|
  house.title "This is the title of a house"
  house.description "This is the description of a house"
  house.image_url 'http://mediacache-s3eu.daft.ie/MZYU1EHKU5Wezk5xuw07WPdRb8VZeof6esL9j1djM-RtPWRhZnQmZT0xNjB4MTIw.jpg'

  house.number 23
  house.street 'Main Street'
  house.town 'Drogheda'
  house.county_id 4

  house.price 200_000
  house.bedrooms 4
end

Factory.define Search do |search|
  search.deposit 50_000
  search.min_payment 700
  search.max_payment 1_200
  search.county_id 4
  search.term 30
end