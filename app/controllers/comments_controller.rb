class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)

    if @comment.save
      session[:commenter_name] = @comment.commenter
      redirect_to article_path(@article)
    else
      @show_comments = cookies[:show_comments] != "false"
      render "articles/show", status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
