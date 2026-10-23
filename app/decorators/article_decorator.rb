class ArticleDecorator
  def initialize(article)
    @article = article
  end

  def preview
    @article.body.truncate(100)
  end

  def word_count
    @article.body.split.size
  end
end
