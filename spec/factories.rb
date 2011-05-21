require "date"

Factory.define House do |house|
  house.daft_title "Mountain View, Co. Wicklow - Semi-Detached House"
  house.description "This is the description of a house"
  house.address "23 Bananatown"
  house.image_url 'http://mediacache-s3eu.daft.ie/MZYU1EHKU5Wezk5xuw07WPdRb8VZeof6esL9j1djM-RtPWRhZnQmZT0xNjB4MTIw.jpg'
  house.price 250_000
  house.county "Wicklow"
  house.daft_id 343532
  house.property_type "Semi-Detached House"
  house.bathrooms 4
  house.bedrooms 5
  house.daft_date_entered Date.civil(2011, rand(5) + 1, rand(31) + 1)
end

Factory.define Search do |search|
  search.deposit 50_000
  search.min_payment 700
  search.max_payment 1_200
  search.location "Mountain View, Wicklow"
  search.term 30
  search.initial_period_length
  search.loan_type "Any"
  search.lender "Any"
end

Factory.define Rate do |rate|
  rate.twenty_year_apr 3.55
  rate.initial_rate 3.5
  rate.lender "Bank of Ireland"
  rate.loan_type "Variable Rate"
  rate.min_ltv 1
  rate.max_ltv 92
end

Factory.define User do |user|
  user.email                 "example@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define Photo do |photo|
  photo.url "http://mediacache-s3eu.daft.ie/PBZXUNU3DvZJXvZzZ-TD-eUvlP3myJN4RVSeNWQrkPJtPWRhZnQmaD00NTA=.jpg"
  photo.height 450
  photo.width 341
  photo.association :house
end

Factory.sequence :photo_url do |n|
  "http://mediacache-s3eu.daft.ie/PBZXUNU3DvZJXvZzZ-#{n}-eUvlP3myJN4RVSeNWQrkPJtPWRhZnQmaD00NTA=.jpg"
end