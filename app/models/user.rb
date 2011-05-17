class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :encryptable
  devise :database_authenticatable, # encrypts and stores a password in the database to validate the authenticity of a user while signing in.
         # :confirmable,              # sends emails with confirmation instructions and verifies whether an account is already confirmed during sign in.
         :recoverable,              # resets the user password and sends reset instructions.
         :rememberable,             # manages generating and clearing a token for remembering the user from a saved cookie.
         :trackable,                # tracks sign in count, timestamps and IP address
         :validatable,              # provides validations of email and password. It’s optional and can be customized, so you’re able to define your own validations.
         :registerable              # handles signing up users through a registration process, also allowing them to edit and destroy their account.
         # :omniauthable              # Allows me to connect to third party providers

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
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

