class Search < ActiveInteraction::Base
  string :query
  string :condition, default: 'Everywhere'

  validates :query, presence: true

  SEARCH_OPTIONS = %w(Questions Answers Comments Users)

  def execute
    safe_query = Riddle::Query.escape(query)

    if condition_include?
      #self.condition = 'Questions' if self.condition == 'Tags'
      self.condition.singularize.constantize.search(safe_query)
    elsif self.condition == 'Tags'
      Question.where("hashtags @> ?", "{#{query}}")
    else
      ThinkingSphinx.search safe_query
    end
  end

  private

  def condition_include?
    SEARCH_OPTIONS.include? self.condition
  end
end

