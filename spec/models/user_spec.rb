require 'spec_helper'

describe User do
  before(:each) do
    @valid_attr = {
      email: "example@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    }
  end

  it "should create a user given valid attributes" do
    User.create! @valid_attr
  end

  describe "validations" do
    it 'should require an email' do
      no_email_user = User.new(@valid_attr.merge :email => '')
      no_email_user.should_not be_valid
    end

    it 'should accept valid email addresses' do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = User.new(@valid_attr.merge :email => address)
        valid_email_user.should be_valid
      end
    end

    it 'should not accept invalid email addresses' do
      addresses = %w[ser@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        valid_email_user = User.new(@valid_attr.merge :email => address)
        valid_email_user.should_not be_valid
      end
    end

    it 'should reject non unique email addresses' do
      User.create!(@valid_attr)
      user_with_duplicate_email = User.new(@valid_attr)
      user_with_duplicate_email.should_not be_valid
    end

    it 'should reject email addresses identical up to case' do
      # create an uppercase varsion of the email from @valid_attr
      upcased_email = @valid_attr[:email].upcase
      # create a user using @valid_attr merged with the uppercase email address
      User.create!(@valid_attr.merge(:email => upcased_email))
      # make a user in memory using the origional @valid_attr attributes
      user_with_duplicate_email = User.new(@valid_attr)
      # check that this user is rejected
      user_with_duplicate_email.should_not be_valid
    end

    describe 'Password validations' do
      it 'should require a password' do
        User.new(@valid_attr.merge(:password => '', :password_confirmation => '')).should_not be_valid
      end

      it 'should require a matching password validation' do
        non_matching_user_details = @valid_attr.merge(:password_confirmation => 'notfoobar')
        User.new(non_matching_user_details).should_not be_valid
      end

      it 'should reject short passwords' do
        short_password = 'a'*5
        User.new(@valid_attr.merge(:password => short_password, :password_confirmation => short_password)).should_not be_valid
      end
    end

    describe 'passord encryption' do
      before :each do
        @user = User.create! @valid_attr
      end

      it 'should have an encrypted password attribute' do
        @user.should respond_to :encrypted_password
      end

      it 'should set the encrypted password' do
        @user.encrypted_password.should_not be_blank
      end

      # the valid password method Verifies whether an incoming_password (ie from sign in) is the user password.
      describe 'valid_password? method' do
        it 'should be true if the passwords match' do
          @user.valid_password?(@valid_attr[:password]).should be_true
        end

        it 'should be false if the passwords dont match' do
          @user.valid_password?('invalid').should be_false
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

