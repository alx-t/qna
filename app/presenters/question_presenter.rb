class QuestionPresenter < Presenter
  def as_json(*)
    {
      id: o.id,
      title: o.title,
      user_id: o.user_id,
      votes_count: o.votes.rating,
      answers_count: o.answers.count,
      view_url: Rails.application.routes.url_helpers.question_path(o.id)
    }
  end
end
