require 'rails_helper'

feature 'User can only delete his answer', %{
  To get a new response from the community
  As an authenticated user
  I would like to be able to delete my answer
} do

  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

  scenario 'Authenticated user delete his answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user is trying to delete a response that is not their own', js: true do
    sign_in(user_not_author)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  describe 'Delete attachment files', js: true do
    scenario 'Author can delete file to his answer' do
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      sign_in(user)
      visit question_path(question)

      click_on 'Delete file rails_helper.rb'
      expect(page).to_not have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'No author trying delete files' do
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      sign_in(user_not_author)
      visit question_path(question)

      expect(page).not_to have_link 'Delete file rails_helper.rb'
    end
  end
end
