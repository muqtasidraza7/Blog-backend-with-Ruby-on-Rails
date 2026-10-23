require "rails_helper"

RSpec.describe ArticleDecorator do
  describe "#preview" do
    it "keeps short text unchanged" do
      article = build(:article, body: "A short article.")
      decorator = described_class.new(article)

      expect(decorator.preview).to eq("A short article.")
    end

    it "shortens long text to 100 characters including the ellipsis" do
      article = build(:article, body: "a" * 120)
      decorator = described_class.new(article)

      expect(decorator.preview).to eq(("a" * 97) + "...")
      expect(article.body).to eq("a" * 120)
    end
  end

  describe "#word_count" do
    it "counts words separated by whitespace" do
      article = build(:article, body: "Learning Rails is fun")
      decorator = described_class.new(article)

      expect(decorator.word_count).to eq(4)
    end
  end
end
