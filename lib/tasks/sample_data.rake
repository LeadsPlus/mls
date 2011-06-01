namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rate.reset
    Search.reset
    County.reset
    User.delete_all
    make_counties
    make_rates
    create_default_search # has to happen after rates else validation fail
    make_user
  end

  namespace :searches do
    desc "Delete all searches from the database"
    task :clear => :environment do
      Search.reset
    end
  end
end

# git push heroku && heroku rake db:reset && heroku rake db:migrate && heroku rake db:p

def delete_default_search
  Search.find(1).destroy
  puts "Default search deleted"
end

def make_user
  User.create!(email: 'dtuite@gmail.com', password: 'foobar', password_confirmation: 'foobar')
end

def create_default_search
  Search.create!({
    max_payment: 1100,
    min_payment: 800,
    deposit: 50000,
    term: 30,
    location: "Enniskillen",
    lender_uids: LENDER_UIDS,
    loan_type_uids: LOAN_TYPE_UIDS,
    bedrooms: ['3', '4', '5'],
    bathrooms: ['1', '2', '3'],
    prop_type_uids: PropertyType.uids
  })
  puts "Default search created"
end

# once I have these in here, I don't technically need the COUNTIES array any more?
# Houses should reference the county id
def make_counties
  1.upto(32) do |i|
    County.create!(name: COUNTIES[i - 1], daft_id: i)
  end
  puts "Counties created"
end

def make_rates
  Rate.create!({
    :twenty_year_apr => 3.0,
    :lender => 'Bank of Ireland',
    :loan_type => 'Variable Rate',
    :min_ltv => 1,
    :max_ltv => 49,
  })

  Rate.create!({
    :twenty_year_apr => 3.1,
    :lender => 'Bank of Ireland',
    :loan_type => 'Variable Rate',
    :min_ltv => 50,
    :max_ltv =>79,
    :min_princ => 500_000
  })

  Rate.create!({
    :twenty_year_apr => 3.0,
    :lender => 'Bank of Ireland',
    :loan_type => 'Variable Rate',
    :min_ltv => 50,
    :max_ltv => 79,
    :max_princ => 500_000
  })

  Rate.create!({
    :twenty_year_apr => 3.3,
    :lender => 'Bank of Ireland',
    :loan_type => 'Variable Rate',
    :min_ltv => 80,
    :max_ltv => 92,
    :min_princ => 500_000
  })

  Rate.create!({
    :twenty_year_apr => 3.4,
    :lender => 'Bank of Ireland',
    :loan_type => 'Variable Rate',
    :min_ltv => 80,
    :max_ltv => 92,
    :max_princ => 500_000
  })

  Rate.create!({
    :twenty_year_apr => 3.5,
    :lender => 'Bank of Ireland',
    :loan_type => '1 Year Fixed Rate',
    :min_ltv => 1,
    :max_ltv => 92,
    :rolls_to => 3.4,
  })

  Rate.create!({
    :twenty_year_apr => 3.7,
    :lender => 'Bank of Ireland',
    :loan_type => '2 Year Fixed Rate',
    :min_ltv => 1,
    :max_ltv => 92,
    :rolls_to => 3.4,
  })

  Rate.create!({
    :twenty_year_apr => 4.0,
    :lender => 'Bank of Ireland',
    :loan_type => '3 Year Fixed Rate',
    :min_ltv => 1,
    :max_ltv => 92,
    :rolls_to => 3.4,
  })

  Rate.create!({
    :twenty_year_apr => 4.0,
    :lender => 'Bank of Ireland',
    :loan_type => '5 Year Fixed Rate',
    :min_ltv => 1,
    :max_ltv => 92,
    :rolls_to => 3.4,
  })

  Rate.create!({
    :twenty_year_apr => 4.7,
    :lender => 'Ulster Bank',
    :loan_type => '2 Year Fixed Rate',
    :min_ltv => 1,
    :max_ltv => 90,
    :rolls_to => 4.4,
  })

  Rate.create!({
    :twenty_year_apr => 5.0,
    :lender => 'Ulster Bank',
    :loan_type => '3 Year Fixed Rate',
    :min_ltv => 1,
    :max_ltv => 90,
    :rolls_to => 4.4,
  })

  Rate.create!({
    :twenty_year_apr => 4.0,
    :lender => 'Ulster Bank',
    :loan_type => 'Variable Rate',
    :min_ltv => 1,
    :max_ltv => 79
  })

  Rate.create!({
    :twenty_year_apr => 4.1,
    :lender => 'Ulster Bank',
    :loan_type => 'Variable Rate',
    :min_ltv => 80,
    :max_ltv => 90
  })

  Rate.create!({
    :twenty_year_apr => 3.13,
    :initial_rate => 3.09,
    :lender => 'AIB',
    :loan_type => 'Variable Rate',
    :min_ltv => 1,
    :max_ltv => 50
  })

  Rate.create!({
    :twenty_year_apr => 3.34,
    :initial_rate => 3.29,
    :lender => 'AIB',
    :loan_type => 'Variable Rate',
    :min_ltv => 51,
    :max_ltv => 79
  })

  Rate.create!({
    :twenty_year_apr => 3.54,
    :initial_rate => 3.49,
    :lender => 'AIB',
    :loan_type => 'Variable Rate',
    :min_ltv => 80,
    :max_ltv => 92
  })

  Rate.create!({
    :twenty_year_apr => 3.40,
    :initial_rate => 4.15,
    :lender => 'AIB',
    :loan_type => '1 Year Fixed Rate',
    :min_ltv => 1,
    :max_ltv => 92,
  })

  Rate.create!({
    :twenty_year_apr => 3.6,
    :initial_rate => 4.65,
    :lender => 'AIB',
    :loan_type => '2 Year Fixed Rate',
    :min_ltv => 1,
    :max_ltv => 92,
  })

  Rate.create!({
    :twenty_year_apr => 3.81,
    :initial_rate => 4.88,
    :lender => 'AIB',
    :loan_type => '3 Year Fixed Rate',
    :min_ltv => 1,
    :max_ltv => 92,
  })

  Rate.create!({
    :twenty_year_apr => 4.07,
    :initial_rate => 5.15,
    :lender => 'AIB',
    :loan_type => '4 Year Fixed Rate',
    :min_ltv => 1,
    :max_ltv => 92,
  })

  Rate.create!({
    :twenty_year_apr => 4.34,
    :initial_rate => 5.35,
    :lender => 'AIB',
    :loan_type => '5 Year Fixed Rate',
    :min_ltv => 1,
    :max_ltv => 92,
  })

  puts "rates created"
end