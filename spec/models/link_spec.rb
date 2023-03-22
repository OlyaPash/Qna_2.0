require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('http://example.com', 'https://example.com').for(:url) }
  it { should_not allow_value('fftp://example.com', 'https ://example.com').for(:url) }

  describe 'gist?' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user_id: user.id) }

    it 'Link is a gist' do
      question.links.create(name: 'My Gist', url: 'https://gist.github.com/OlyaPash/a1998a9c90a501eb807dbae01d60ba32')

      expect(question.links.first).to be_gist
    end

    it 'Link is not a gist' do
      question.links.create(name: 'Google', url: 'https://www.google.com/')

      expect(question.links.first).to_not be_gist
    end
  end
end
