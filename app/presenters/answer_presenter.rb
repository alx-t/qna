class AnswerPresenter < Presenter
  def as_json(*)
    {
      id: o.id,
      question_id: o.question_id,
      body: o.body,
      user_id: o.user_id,
      question_user_id: o.question.user_id,
      is_best: o.is_best,
      upvotes: o.votes.upvotes.rating,
      downvotes: o.votes.downvotes.rating,
      rating: o.votes.rating,
      destroy_url: "answer_path(id: #{o.id})",
      vote_up_url: "vote_up_question_answer_path(id: #{o.id}, question_id: #{o.question_id})",
      vote_down_url: "vote_down_question_answer_path(id: #{o.id}, question_id: #{o.question_id})",
      vote_reset_url: "vote_reset_question_answer_path(id: #{o.id}, question_id: #{o.question_id})"
    }
  end
end

