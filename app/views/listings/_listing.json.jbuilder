json.extract! listing, :id, :title, :description, :price, :sold, :user_id, :category_id, :created_at, :updated_at
json.url listing_url(listing, format: :json)
