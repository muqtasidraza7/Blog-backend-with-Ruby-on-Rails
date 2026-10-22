require "rails_helper"

RSpec.describe Article, type: :model do
  describe "validations" do
    let(:body) { "A body long enough to pass validation." }

    let(:article) do
      build(:article, body: body)
    end

    it "is valid with valid attributes" do
      expect(article).to be_valid
    end

    context "when the title is missing" do
      it "is invalid and reports a title error" do
        article.title = nil

        expect(article).not_to be_valid
        expect(article.errors[:title]).to include("can't be blank")
      end
    end

    context "when the body is missing" do
      let(:body) { nil }

      it "is invalid and reports a body presence error" do
        expect(article).not_to be_valid
        expect(article.errors[:body]).to include("can't be blank")
      end
    end

    context "when the body has nine characters" do
      let(:body) { "a" * 9 }

      it "is invalid and reports a minimum-length error" do
        expect(article).not_to be_valid

        expect(article.errors[:body]).to include(
          "is too short (minimum is 10 characters)"
        )
      end
    end

    context "when the body has exactly ten characters" do
      let(:body) { "a" * 10 }

      it "is valid" do
        expect(article).to be_valid
      end
    end

    context "when the body has eleven characters" do
      let(:body) { "a" * 11 }

      it "is valid" do
        expect(article).to be_valid
      end
    end
  end
  describe "destroying an article" do
    it "destroys its comments and keep comments of other articels" do
      article = create(:article,title:"Article to delete", body:"This article should be deleted")
  other_article = create(:article,title:"Article to Keep", body:"This article should remain")

    first_comment = create(:comment,
    article: article,
    body:"First Comment"
    )

    second_comment = create(:comment, 
    article: article,
    commenter:"Sara",
    body:"Second Comment")
    other_comment = create(
      :comment,
      article: other_article,
      commenter: "Ahmed",
      body: "Keep this comment."
      )

    expect {
      article.destroy!
    }.to change(Comment, :count).by(-2)
    expect(Comment.exists?(first_comment.id)).to be false
    expect(Comment.exists?(second_comment.id)).to be false
    expect(Comment.exists?(other_comment.id)).to be true
    expect(Article.exists?(other_article.id)).to be true
  end
  end
  end
