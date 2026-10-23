module ApplicationHelper
  def publication_date(article)
    article.created_at.strftime("%d %b %Y")
  end
end
