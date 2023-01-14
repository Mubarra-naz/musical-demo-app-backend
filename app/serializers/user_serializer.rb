class UserSerializer
  include FastJsonapi::ObjectSerializer
  set_type :user
  attributes :id, :email, :created_at, :first_name, :last_name
  attribute :authToken do |obj, params|
    params[:token] if params && params[:token].present?
  end
end
