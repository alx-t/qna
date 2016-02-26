module QuestionsHelper

  def hashtag_links(text)
    text.gsub(/#\w*/) { |m| show_link m }
  end

  private

  def show_link(text)
    link_to text, search_path( query: { query: text, condition: "Tags" })
  end
end

