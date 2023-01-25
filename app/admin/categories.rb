ActiveAdmin.register Category do
  permit_params :name, sub_categories_attributes: [:id, :name, :category_id, :_destroy]

  form do |f|
    f.inputs "Details" do
      f.input :name
    end
    f.has_many :sub_categories, heading: "Sub Categories", button_label: "Add Sub category", allow_destroy: true do |n_f|
      n_f.input :name
    end
    f.actions
  end

  filter :category, as: :select, collection: proc { Category.categories }
  filter :sub_categories, as: :select, collection: proc { Category.sub_categories }
  filter :name, filters: [:contains, :equals, :starts_with, :ends_with]
  filter :created_at
  filter :updated_at
end
