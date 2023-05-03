require 'rails_helper'

feature 'User can edit their questions', %{
  In order to correct mistakes
  As an author of question
  I would like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:user_not_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/OlyaPash/a1998a9c90a501eb807dbae01d60ba32' }

  describe 'Authenticated user', js: true do
    scenario 'edits their questions' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within '.question' do
        fill_in 'Body', with: 'edited'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited'
      end
    end

    scenario 'edited his question with errors' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'
      
      within '.question' do
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      within '.question-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(user_not_author)
      visit question_path(question)
      
      within '.question' do
        expect(page).to_not have_link 'Edit question'
      end
    end

    scenario 'edit a question with attached file' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edit a question with add links' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within '.question' do
        fill_in 'Body', with: 'edited'
        click_on 'Add link'
        
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Save'

        expect(page).to have_link 'My gist', href: gist_url
      end
    end
  end

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question' 
  end
end
