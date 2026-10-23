require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "access without signing in" do
    it "allows visitors to read articles" do
      get articles_path

      expect(response).to have_http_status(:ok)
    end

    it "redirects visitors to sign in before creating an article" do
      get new_article_path

      expect(response).to redirect_to(new_session_path)
    end
  end
  describe "signing in" do
    let(:password) { "Development-test-password-123!" }
    let!(:user) { create(:user, password: password) }
     it "creates a login session and allows access to a protected page" do
    expect {
      post session_path, params: {
        email_address: user.email_address,
        password: password
      }
    }.to change { user.sessions.count }.by(1)

    expect(response).to redirect_to(root_url)

    get new_article_path

    expect(response).to have_http_status(:ok)
  end
  it "rejects an incorrect password without creating a login session" do
  expect {
    post session_path, params: {
      email_address: user.email_address,
      password: "incorrect-password"
    }
  }.not_to change(Session, :count)

  expect(response).to redirect_to(new_session_path)

  follow_redirect!

  expect(response.body).to include(
    "Try another email address or password."
  )

  get new_article_path

  expect(response).to redirect_to(new_session_path)
end
it "returns the user to the protected page requested before signing in" do
  get new_article_path

  expect(response).to redirect_to(new_session_path)

  post session_path, params: {
    email_address: user.email_address,
    password: password
  }

  expect(response).to redirect_to(new_article_url)

  follow_redirect!

  expect(response).to have_http_status(:ok)
end
  end
  describe "signing out" do
  it "removes the login session and blocks subsequent protected requests" do
    password = "Development-test-password-123!"
    user = create(:user, password: password)

    post session_path, params: {
      email_address: user.email_address,
      password: password
    }

    expect(response).to redirect_to(root_url)
    expect(user.sessions.count).to eq(1)

    expect {
      delete session_path
    }.to change { user.sessions.count }.from(1).to(0)

    expect(response).to have_http_status(:see_other)
    expect(response).to redirect_to(new_session_path)

    get new_article_path

    expect(response).to redirect_to(new_session_path)
  end
end
end
