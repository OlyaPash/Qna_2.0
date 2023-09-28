require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "notification" do
    let!(:user) { create(:user) }
    let(:question) { create(:question, user_id: user.id) }
    let(:answer) { create(:answer, question: question, user_id: user.id) }
    let(:mail) { NotificationMailer.notification(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notification")
      expect(mail.to).to eq ([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New answer for your question")
    end
  end
end
