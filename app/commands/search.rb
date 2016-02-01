class Search < ActiveInteraction::Base
  string :query
  string :condition, default: 'Everywhere'

  validates :query, presence: true

  SEARCH_OPTIONS = %w(Questions Answers Comments Users)

  def execute
    safe_query = Riddle::Query.escape(query)

    if condition_include?
      condition.singularize.constantize.search(safe_query)
    else
      ThinkingSphinx.search safe_query
    end
  end

  private

  def condition_include?
    SEARCH_OPTIONS.include? self.condition
  end
end

