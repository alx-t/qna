class CommentPresenter < Presenter
  def as_json(*)
    {
      id: o.id,
      body: o.body,
      commentable_type: o.commentable_type
    }
  end
end

