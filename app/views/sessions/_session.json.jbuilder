json.extract! session, :id, :user_id, :datetime, :part, :content, :memo, :body_weight, :body_fat, :created_at, :updated_at
json.url session_url(session, format: :json)
