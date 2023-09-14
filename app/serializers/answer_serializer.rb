class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :best

  has_many :links
  has_many :files
  has_many :comments

  belongs_to :question
  belongs_to :user

  def files
    object.files.map { |file| rails_blob_url(file, host: :localhost) }
  end
end
