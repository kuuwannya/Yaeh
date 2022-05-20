class CommentsController < ApplicationController
before_action :comment_find, only:  [:update, :destroy]
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to post_path(comment.post), success: t('.success')
    else
      redirect_to post_path(comment.post), danger: t('.fail')
    end
  end

  def update
    @comment = current_user.comments.find(params[:id])
    if @comment.update(comment_update_params)
      render json: { comment: @comment }, status: :ok
    else
      render json: { comment: @comment, errors: { messages: @comment.errors.full_messages } }, status: :bad_request
    end
  end

  def destroy
    @comment.destroy!
  end

  private
  def comment_params
    params.require(:comment).permit(:content).merge(post_id: params[:post_id])
  end

  def comment_find
    @comment = current_user.comments.find(params[:id])
  end

  def comment_update_params
    params.require(:comment).permit(:body)
  end
end
