class Order < ApplicationRecord
  belongs_to :product
  belongs_to :buyer
  belongs_to :seller
end
