class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file.purge if current_user.author?(@file.record)
  end
end
