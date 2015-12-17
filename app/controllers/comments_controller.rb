class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable
  after_action :publish_comment, only: :create

  respond_to :json

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
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
        "/questions/#{@commentable.question.id}/comments"
    end
  end

  def publish_comment
    PrivatePub.publish_to comment_path, comment: CommentPresenter.new(@comment).to_json if @comment.errors.empty?
  end
end

