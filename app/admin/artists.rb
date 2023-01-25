ActiveAdmin.register User, as: "Artist" do
  permit_params :first_name, :last_name, :email

  form do |f|
    f.inputs "Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :role, required: true, as: :hidden, :input_html => { :value => User::ARTIST }
    end

    f.actions do
      f.action :submit, label: "Save Artist"
      f.cancel_link
    end
  end

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :created_at
    column :updated_at
    column :role
    actions
  end

  filter :first_name_or_last_name_cont, as: :string, label: "Name"
  filter :email
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :role
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  controller do
    def scoped_collection
      end_of_association_chain.artist
    end
  end
end
