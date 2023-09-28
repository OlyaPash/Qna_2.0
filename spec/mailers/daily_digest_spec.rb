require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let!(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }
    let(:yesterday_questions) { create_list(:question, 2, :created_at_yesterday) }

    it "renders the headers" do
      expect(mail.subject).to eq('Digest')
      expect(mail.to).to eq ([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match('Hi! Daily digest for you! New created questions')
    end
  end

end
