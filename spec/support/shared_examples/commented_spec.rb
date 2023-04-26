require 'rails_helper'

RSpec.shared_examples 'commented' do
  let!(:commented) { described_class.controller_name.classify.constantize }
  let!(:commentable) { create(commented.to_s.underscore.to_sym, user: user) }
  let!(:user) { create(:user) }

  describe 'POST #comment' do
    context 'Authenticated user' do

      it 'create comment for question' do
        login(user)

        expect do
          post :comment, params: { id: commentable, comment: attributes_for(:question), format: :js }
        end.to change {
                  commentable.comments.count
               }.by(1)
      end

      it 'create comment for answer' do
        login(user)

        expect do
          post :comment, params: { id: commentable, comment: attributes_for(:answer), format: :js }
        end.to change {
                  commentable.comments.count
               }.by(1)
      end
    end
  end
end
