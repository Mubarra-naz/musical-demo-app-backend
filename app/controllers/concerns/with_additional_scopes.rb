module WithAdditionalScopes
  extend ActiveSupport::Concern
  DEFAULT_PAGE = 0.freeze
  PER_PAGE = 5.freeze
  ASC = 'asc'.freeze
  DESC = 'desc'.freeze
  DIRECTIONS = [ASC, DESC].freeze
  DEFAULT_SORT_COL = 'created_at'.freeze

  def paginate_scope(scope)
    scope = scope.page(params[:page] || 0).per(params[:per] || 3)
  end

  def sort_scope(scope)
    scope = scope.order("#{params[:sort_by] || DEFAULT_SORT_COL} #{params[:sort_order].in?(DIRECTIONS) || ASC}")
  end
end
