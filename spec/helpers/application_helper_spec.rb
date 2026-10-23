require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#publication_date" do
    it "formats the article creation date" do
      article = build(
        :article,
        created_at: Time.zone.local(2026, 10, 23, 12)
      )

      expect(helper.publication_date(article)).to eq("23 Oct 2026")
    end
  end
end
