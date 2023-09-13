class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :short_title
  
  has_many :answers
  has_many :links
  has_many :files
  has_many :comments
  belongs_to :user

  def short_title
    object.title.truncate(7)
  end

  def files
    object.files.map { |file| rails_blob_url(file, host: :localhost) }
  end
end
