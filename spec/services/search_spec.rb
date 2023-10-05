require 'rails_helper'

RSpec.describe SearchService do
  it 'method call' do
    SearchService.new(query: 'search object', type: 'Question').call
  end
end
