require "date"

Factory.define PropertyType do |t|
  t.name "Detached House"
  t.uid "Detached"
end

Factory.define House do |house|
  house.daft_title "Mountain View, Co. Wicklow - Semi-Detached House"
  house.description "This is the description of a house"
  house.address "23 Bananatown"
  house.image_url 'http://mediacache-s3eu.daft.ie/MZYU1EHKU5Wezk5xuw07WPdRb8VZeof6esL9j1djM-RtPWRhZnQmZT0xNjB4MTIw.jpg'
  house.price 250_000
  house.daft_id 343532
  house.property_type "Semi-Detached House"
  house.bathrooms 4
  house.bedrooms 5
  house.region_name "Co. Wicklow"
  house.association :town
  house.association :county
end

Factory.define Search do |search|
  search.max_payment 1100
  search.min_payment 800
  search.deposit 50000
  search.term 30
  search.locations ['2367', '2364', '2358']
  search.lender_uids LENDER_UIDS
  search.loan_type_uids LOAN_TYPE_UIDS
  search.bedrooms ['3', '4', '5']
  search.bathrooms ['1', '2', '3']
  # search.prop_type_uids PropertyType.uids
  search.association :rate
  search.association :usage
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

Factory.sequence :email do |n|
  "example-#{n}@example.com"
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

Factory.define Town do |c|
  c.name "Eniskillen"
  c.daft_id "3fe3"
  c.county "Fermanagh"
end

Factory.define County do |c|
  c.name "Fermanagh"
  c.daft_id 30
  c.id 30
end

Factory.define Usage do |u|
  u.ip_address "227.343.231.653"
  u.user_agent 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_7) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.91 Safari/534.30'
end
