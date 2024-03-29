require 'rails_helper'

feature 'User can add links to question', %{
  In order to provide additional info my question
  As an questions author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/OlyaPash/a1998a9c90a501eb807dbae01d60ba32' }

  describe 'User add' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'correct links' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text text text'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'invalid links' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text text text'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'chtoto'

      click_on 'Ask'

      expect(page).to have_content 'Links url are not valid'
    end
  end
end
