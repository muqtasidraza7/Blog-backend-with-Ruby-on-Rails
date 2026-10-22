class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    @comment = @article.comments.build(
      commenter:session[:commenter_name]
    )
    @show_comments = cookies[:show_comments] != "false"
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  def comment_visibility
    @article=Article.find(params[:id])
    cookies[:show_comments]={
      value: params[:show_comments] == "false" ? "false": "true",
      expires: 30.day.from_now,
      httponly: true,
      same_site: :lax
    }

    redirect_to article_path(@article), status: :see_other
  end

  private
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
