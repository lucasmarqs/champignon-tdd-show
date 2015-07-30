require 'rails_helper'

RSpec.describe Blogs::PostsController, :type => :controller do

  context 'when #index' do
    subject { get :index }

    it { expect(subject).to be_success }

    it "assigns @posts" do
      expect(assigns(:post).to_a).to match_array(Post.all)
    end
    
  end
end
