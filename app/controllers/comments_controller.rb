class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      p @comment
      p comment: render_to_string('comments/show')
      p comment_path
      PrivatePub.publish_to comment_path, comment: render_to_string('comments/show')
      render nothing: true
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def load_commentable
    @commentable = commentable_klass.find(params[commentable_id])
  end

  def commentable_klass
    params[:commentable].classify.constantize
  end

  def commentable_id
    (commentable_name + '_id').to_sym
  end

  def commentable_name
    params[:commentable].singularize
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def comment_path
    case commentable_name
      when 'question'
        "/questions/#{@commentable.id}/comments"
      when 'answer'
        "/questions/#{@commentable.question.id}/answers/#{@commentable.id}/comments"
    end
  end
end

