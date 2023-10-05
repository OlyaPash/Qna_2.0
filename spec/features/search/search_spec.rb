require 'sphinx_helper'

feature 'User can search for answer, question, comment, user and all', "
  In order to find needed informations
  As a User
  I'd like to be able to use the search
" do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:comment) { create(:comment, commentable: question, user: user) }

  background { visit questions_path }

  scenario 'No result', sphinx: true do

    ThinkingSphinx::Test.run do
      fill_in :query, with: 'title'
      click_on 'Search'

      expect(page).to have_content 'No result'
    end
  end

  scenario 'User searches All', sphinx: true do

    ThinkingSphinx::Test.run do
      select 'All', from: :type
      fill_in :query, with: question.title
      click_on 'Search'

      expect(page).to have_content question.title
    end
  end

  scenario 'User searches for Answer', sphinx: true do

    ThinkingSphinx::Test.run do
      select 'Answer', from: :type
      fill_in :query, with: answer.body
      click_on 'Search'

      expect(page).to have_content answer.body
    end
  end

  scenario 'User searches for Comment', sphinx: true do

    ThinkingSphinx::Test.run do
      select 'Comment', from: :type
      fill_in :query, with: comment.body
      click_on 'Search'

      expect(page).to have_content comment.body
    end
  end
end
