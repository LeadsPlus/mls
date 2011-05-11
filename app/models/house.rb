class House < ActiveRecord::Base
  attr_accessible :title, :price, :description, :county, :image_url, :daft_id
  default_scope order('price')
  paginates_per(10)

  def daft_url
    "http://www.daft.ie/searchsale.daft?id=#{daft_id}"
  end

  def ltv(princ)
    (princ*100)/price
  end

  validates :title, :presence => true

  validates :county, :presence => true

  validates :price, :presence => true,
                    :numericality => { :greater_than => 1 }

  validates :daft_id, :presence => true,
                      :numericality => { :greater_than => 0 }

end






# == Schema Information
#
# Table name: houses
#
#  id          :integer         not null, primary key
#  price       :integer
#  created_at  :datetime
#  updated_at  :datetime
#  county      :string(255)
#  image_url   :string(255)
#  description :text
#  title       :string(255)
#  daft_id     :integer
#

