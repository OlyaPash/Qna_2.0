class SearchController < ApplicationController
  skip_authorization_check

  def search
    @result = SearchService.new(search_params).call
  end

  def search_params
    params.permit(:query, :type)
  end
end
