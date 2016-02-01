class SearchController < ApplicationController
  authorize_resource

  def search
    outcome = Search.run(params[:query])
    outcome.valid? ? @results = outcome.result : @results = []
    respond_with @results
  end
end

