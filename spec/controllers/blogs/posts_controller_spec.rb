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

    before { sign_in user }

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

    before { get :show, id: saved_post }

    it 'assigns @post' do
      expect(assigns(:post)).to eq(saved_post)
    end

    context 'when rendering views' do
      render_views

      it { is_expected.to render_template :show }
    end
  end

  context 'when #edit' do
    
    subject { get :edit, id: saved_post }

    context 'when current user matches to post' do

      before { sign_in saved_post.user }

      it 'assigns @post' do
        get :edit, id: saved_post
        expect(assigns(:post)).to eq(saved_post)
      end

      context 'when rendering views' do

        render_views

        it { is_expected.to render_template :edit }
      end
    end

    context 'when current user doesn\'t match to post' do

      before { sign_in user}

      it 'renders #index' do
        expect(subject).to render_template :index
      end
    end
  end

  context 'when #update' do

    before { sign_in user }

    context 'with params' do

      it do
        is_expected.to permit(:title, 
          :content, 
          :user_id).for(:update, params: { :id => saved_post, post: attributes_for(:post) })
      end
    end

    context "with valid attributes" do

      before do
        @new_title = Faker::Lorem.sentence(1)
        patch :update, :id => saved_post, post: attributes_for(:post, title: @new_title)
      end

      it "updates a post" do
        expect(Post.find(saved_post.id).title).to eq(@new_title)
      end

      it "redirects to #show" do
        expect(response).to redirect_to blogs_path saved_post     
      end
    end

    context "with invalid attributes" do
      before { patch :update, :id => saved_post, post: attributes_for(:post, title: nil) }

      it 'doesn\'t update a post' do
        expect(Post.find(saved_post.id).title).to eq(saved_post.title)
      end

      it { is_expected.to render_template :edit }
    end
  end
end
