json.extract! @question, :id, :title, :user_id
json.votes_count @question.votes.count
json.answers_count @question.answers.count
json.view_url question_path(@question)

