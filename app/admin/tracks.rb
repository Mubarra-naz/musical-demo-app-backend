ActiveAdmin.register Track do
  permit_params :audio, :name, :status, :price, :category_id, :remove_audio, artist_tracks_attributes: [:user_id, :track_id, :_destroy]

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :audio, as: :file, hint: f.object.audio.try(:url)
      # div do
      # span link_to 'remove current audio', remove_audio_admin_track_path(f.object), data: { confirm: 'Do you want to remove this audio?' }, method: :delete, remote: true if f.object.audio.persisted?
      # end
      f.input :price
      f.input :status, as: :select, collection: Track::STATUSES, include_blank: false
      f.input :category_id, as: :select, collection: Category.sub_categories
    end
    f.has_many :artist_tracks, heading: "Artists", allow_destroy: true do |s|
      s.input :user_id, as: :select, collection: User.artist.pluck(:email, :id)
    end
    f.semantic_errors
    f.actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :status
    column :category do |track|
      track.sub_category.category.name
    end
    column :sub_category do |track|
      track.sub_category.name
    end
    column :artist do |track|
      track.artist_tracks.map{|at| at.artist.email}.join(", ")
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :audio do |track|
        audio_tag(url_for(track.audio), controls: true) if track.audio.attached?
      end
      row :price
      row :status
      row :artist do |track|
        track.artist_tracks.map{|at| at.artist.email}.join(", ")
      end
      row :category do |track|
        track.sub_category.category.name
      end
      row :sub_category do |track|
        track.sub_category.name
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  filter :name_contains
  filter :price
  filter :status, as: :check_boxes, collection: proc { Track::STATUSES }
  filter :sub_category, as: :select, collection: proc { Category.sub_categories }
  filter :created_at
  filter :updated_at

  # member_action :remove_audio, method: :delete do
  #   track = Track.find(params[:id])
  #   track.purge_audio if track.audio.attached?
  # end
end
