require 'rails_helper'

RSpec.describe Blogs::PostsController, :type => :controller do

  let(:user){ create(:user) }
  let(:saved_post){ create(:post) }

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
 
  context 'when #create' do
    context 'with params' do
      it do
        is_expected.to permit(:title, 
          :content,
          :user_id).for(:create, params: { post: attributes_for(:post) })
      end
    end

    context 'with valid attributes' do

      it 'creates a new post' do
        expect do
          post :create, post: attributes_for(:post)
        end.to change(Post, :count).by(1)
      end

      it 'redirects to index' do
        post :create, post: attributes_for(:post)
        expect(response).to redirect_to blogs_root_path
      end
    end

    context 'with invalid attributes' do

      it 'doesn\'t create post' do
        expect do
          post :create, post: attributes_for(:post).except(:title)
        end.to_not change(Post, :count)
      end

      it 'renders new' do
        post :create, post: attributes_for(:post).except(:title)
        expect(response).to render_template(:new)
      end
    end
  end

  context 'when #show' do

    before { get :show, id: saved_post.id }

    it 'assigns @post' do
      expect(assigns(:post)).to eq(saved_post)
    end

    context 'when rendering views' do
      render_views

      it { is_expected.to render_template :show }
    end
  end
end
