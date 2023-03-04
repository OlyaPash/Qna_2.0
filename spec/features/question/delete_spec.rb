require 'rails_helper'

feature 'User can only delete his auestion', %{
  To get a new response from the community
  As an authenticated user
  I would like to be able to delete my question
} do

  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }

  scenario 'Authenticated user delete his question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question successfully delete.'
  end

  scenario 'Authenticated user is trying to delete question that is not their own' do
    sign_in(user_not_author)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
