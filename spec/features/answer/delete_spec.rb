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

  scenario 'Authenticated user delete his answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Your answer successfully delete.'
  end

  scenario 'Authenticated user is trying to delete a response that is not their own' do
    sign_in(user_not_author)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

end
