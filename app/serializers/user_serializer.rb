class UserSerializer < BaseSerializer
  set_type :user
  attributes :id, :email, :created_at, :first_name, :last_name
end
