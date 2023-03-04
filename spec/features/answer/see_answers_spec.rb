require 'rails_helper'

feature 'Guest can view the question and its answers', %{
  To find answers
  As a user
  I want to be able to view all answers to a question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'can view the question and its answers' do
      sign_in(user)

      visit question_path(question)
      answers.each { |answer| expect(page).to have_content(answer.body) }
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can view the question and its answers' do
      
      visit question_path(question)
      answers.each { |answer| expect(page).to have_content(answer.body) }
    end
  end
end
