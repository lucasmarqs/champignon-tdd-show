require 'rails_helper'

RSpec.describe Post, :type => :model do
  
  context 'when validating' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_length_of(:title).is_at_most(60) }
    it { is_expected.to validate_length_of(:content).is_at_least(10).is_at_most(140) }
  end
end
