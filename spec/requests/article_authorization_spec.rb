require "rails_helper"

RSpec.describe "Article authorization", type: :request do
  let(:owner) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:article) { create(:article, user: owner) }

  def sign_in(user)
    post session_path, params: {
      email_address: user.email_address,
      password: user.password
    }
    expect(response).to have_http_status(:found)
  end

  it "allows visitors to read articles without showing owner controls" do
    get article_path(article)

    expect(response).to have_http_status(:ok)
    expect(response.body).not_to include(edit_article_path(article))
  end

  it "rejects unauthenticated changes" do
    patch article_path(article), params: { article: { title: "Unauthorized" } }
    expect(response).to redirect_to(new_session_path)
    expect(article.reload.title).not_to eq("Unauthorized")

    expect {
      delete article_path(article)
    }.not_to change(Article, :count)
    expect(response).to redirect_to(new_session_path)
  end

  it "assigns new articles to the authenticated user despite a supplied user ID" do
    sign_in(owner)

    expect {
      post articles_path, params: {
        article: { title: "Owned article", body: "A sufficiently long body", user_id: other_user.id }
      }
    }.to change { owner.articles.count }.by(1)

    created_article = owner.articles.order(:id).last
    expect(response).to redirect_to(article_path(created_article))
  end

  it "allows the owner to edit and update without transferring ownership" do
    sign_in(owner)
    get edit_article_path(article)
    expect(response).to have_http_status(:ok)

    patch article_path(article), params: {
      article: { title: "Updated by owner", user_id: other_user.id }
    }
    expect(response).to redirect_to(article_path(article))
    expect(article.reload.title).to eq("Updated by owner")
    expect(article.user_id).to eq(owner.id)
  end

  it "allows the owner to delete their article" do
    sign_in(owner)

    expect {
      delete article_path(article)
    }.to change(Article, :count).by(-1)
    expect(response).to redirect_to(root_path)
  end

  it "rejects another user's edit, update, and delete requests" do
    sign_in(other_user)
    get edit_article_path(article)
    expect(response).to have_http_status(:not_found)

    original_title = article.title
    patch article_path(article), params: { article: { title: "Unauthorized" } }
    expect(response).to have_http_status(:not_found)
    expect(article.reload.title).to eq(original_title)

    expect {
      delete article_path(article)
    }.not_to change(Article, :count)
    expect(response).to have_http_status(:not_found)

    get article_path(article)
    expect(response).to have_http_status(:ok)
    expect(response.body).not_to include(edit_article_path(article))
  end
end
