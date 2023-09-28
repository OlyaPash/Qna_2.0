require 'rails_helper'

RSpec.describe NotificationService do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  let(:answer) { create(:answer, question: question, user_id: user.id) }

  it 'send notification' do
    NotificationService.new(answer).send_notification
  end
end
