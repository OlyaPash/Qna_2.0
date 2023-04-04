require 'rails_helper'

RSpec.shared_examples 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let(:votable) { create described_class.to_s.underscore.to_sym }
    let!(:likes) { create_list :vote, 3, :like, votable: votable }
    let!(:dislikes) { create_list :vote, 1, :dislike, votable: votable }

    it 'sum' do
      expect(votable.rating).to eq 2
    end
  end
end
