class SearchService
  TYPES = %w[All Question Answer Comment User].freeze

  def initialize(params)
    @query = params[:query]
    @type = params[:type]
  end

  def call
    return [] if @query.empty?

    @type == 'All' ? ThinkingSphinx.search(@query) : Object.const_get(@type).search(@query)
  end
end


