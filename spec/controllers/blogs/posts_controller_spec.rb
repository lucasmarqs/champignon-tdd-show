require 'rails_helper'

RSpec.describe Blogs::PostsController, :type => :controller do

  let(:user){ create(:user) }
  let(:post){ create(:post) }

  context 'when #index' do
    subject { get :index }

    it { expect(subject).to be_success }

    it "assigns @posts" do
      expect(assigns(:post).to_a).to match_array(Post.all)
    end

    context "when rendering views" do
      render_views

      context "without collection data" do
        it "renders template" do
          expect(subject).to render_template(:index)
        end
      end

      context "with collection data" do
        it "renders template" do
          create_list :post, 3
          expect(subject).to render_template(:index)
        end
      end
    end
  end

  context 'when #new' do

    before { sign_in user }

    it 'assigns @post' do
      get :new 
      expect(assigns(:post)).to be_a_new(Post)
    end

    context "when rendering views" do
      render_views
      it "renders template" do
        get :new
        expect(response).to render_template(:new)
      end
    end  
  end

end
