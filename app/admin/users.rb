ActiveAdmin.register User do
  actions :index, :show, :destroy

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :created_at
    column :updated_at
    column :provider
    column :role
    actions
  end

  filter :first_name_or_last_name_cont, as: :string, label: "Name"
  filter :email
  filter :provider_equals
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :provider
      row :role
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  controller do
    def scoped_collection
      end_of_association_chain.user
    end
  end
end
