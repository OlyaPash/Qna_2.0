require 'rails_helper'

feature 'User can add badge to question', %{
  To reward the best answer to my question
  As a questions author
  I would like to be able to add badge
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'User can adds badge when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text text'

    fill_in 'Badge name', with: 'Badge'
    attach_file 'Image', "#{Rails.root}/app/assets/images/gold-medal.jpg"

    click_on 'Ask'

    expect(page).to have_content 'Badge'
  end
end
