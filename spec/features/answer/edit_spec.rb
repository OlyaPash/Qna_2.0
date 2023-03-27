require 'rails_helper'

feature 'User can edit his answer', %{
  In order to correct mistakes
  As an author of answer
  I would like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:gist_url) { 'https://gist.github.com/OlyaPash/a1998a9c90a501eb807dbae01d60ba32' }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edited his answer with errors' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'
      
      within '.answers' do
        fill_in 'answer_body', with: ''
        click_on 'Save'
      end

      within '.answer-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in(other_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit answer'
      end
    end

    scenario 'edit a answer with attached file' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with add links' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Add link'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
        click_on 'Save'

        expect(page).to have_link 'My gist', href: gist_url
      end
    end
  end
end
