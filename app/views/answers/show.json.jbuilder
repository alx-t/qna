json.extract! @answer, :id, :question_id, :body, :user_id
json.upvotes @answer.votes.upvotes.rating
json.downvotes @answer.votes.downvotes.rating
json.rating @answer.votes.rating
json.voted @answer.voted_for? current_user
json.vote_up_url vote_up_question_answer_path(id: @answer, question_id: @answer.question_id)
json.vote_down_url vote_down_question_answer_path(@answer, question_id: @answer.question_id)
json.vote_reset_url vote_reset_question_answer_path(@answer, question_id: @answer.question_id)
json.destroy_url question_answer_path(id: @answer.id, question_id: @answer.question_id)
json.set_best_url set_best_question_answer_path(question_id: @answer.question_id, id: @answer.id)

json.attachments @answer.attachments do |a|
  json.id a.id
  json.file_name a.file.identifier
  json.file_url a.file.url
end

