class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "are not valid"}
end
