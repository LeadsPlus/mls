Factory.define House do |house|
  house.title "This is the title of a house"
  house.description "This is the description of a house"
  house.image_url 'http://mediacache-s3eu.daft.ie/MZYU1EHKU5Wezk5xuw07WPdRb8VZeof6esL9j1djM-RtPWRhZnQmZT0xNjB4MTIw.jpg'
  house.price 250_000
  house.county "Wicklow"
  house.daft_id 343532
end

Factory.define Search do |search|
  search.deposit 50_000
  search.min_payment 700
  search.max_payment 1_200
  search.county "Wicklow"
  search.term 30
  search.initial_period_length
  search.loan_type "Any"
  search.lender "Any"
end

Factory.define Rate do |rate|
  rate.initial_rate 3.5
  rate.lender "Bank of Ireland"
  rate.loan_type "Variable Rate"
  rate.min_ltv 1
  rate.max_ltv 92
end