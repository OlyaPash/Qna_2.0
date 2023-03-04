require 'rails_helper'

feature 'User can view the list of questions', %{
  In order to find the question is interested
  As a user 
  I want to be able to view all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  describe 'Authenticated user' do
    scenario 'sees a list all questions' do
      sign_in(user)

      visit questions_path
      questions.each { |question| expect(page).to have_content(question.title) }
    end
  end

  describe 'Unauthenticated user' do
    scenario 'sees a list all questions' do
      visit questions_path
      questions.each { |question| expect(page).to have_content(question.title) }
    end
  end
end

