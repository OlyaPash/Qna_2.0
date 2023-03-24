require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  let(:user) { create(:user) }
  let(:questions) { create_list(:question, 3, user: user) }

  describe "GET #index" do
    before { login(user) }
    let(:badges) { user.badges.push(Badge.create([{name: 'One', question: questions[0]},
                                                  {name: 'Two', question: questions[1]},
                                                  {name: 'Three', question: questions[2]}]))}

    it "populates array of users badges" do
      get :index
      expect(assigns(:badges)).to match_array(badges)
    end
  end

end
