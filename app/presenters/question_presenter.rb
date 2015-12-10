class QuestionPresenter < Presenter
  def as_json(*)
    {
      id: o.id,
      title: o.title,
      body: o.body,
      user_id: o.user_id,
      upvotes: o.votes.upvotes.rating,
      downvotes: o.votes.downvotes.rating,
      rating: o.votes.rating,
      vote_up_url: o.vote_up_question_answer_path(id: o.id, question_id: o.question_id),
      vote_down_url: o.vote_down_question_answer_path(id: o.id, question_id: o.question_id),
      vote_reset_url: o.vote_reset_question_answer_path(id: o.id, question_id: o.question_id)
    }
  end
end
