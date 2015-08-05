require 'rails_helper'

RSpec.describe Blogs::PostsController, :type => :controller do

  let(:user){ create(:user) }
  let(:saved_post){ create(:post) }

  describe '#index' do
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

        before { create_list :post, 3 }

        it "renders template" do
          expect(subject).to render_template(:index)
        end
      end
    end
  end

  describe '#new' do

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
 
  describe '#create' do

    before { sign_in user }

    context 'with params' do
      it do
        is_expected.to permit(:title, 
          :content,
          :user_id).for(:create, params: { post: attributes_for(:post) })
      end
    end

    context 'with valid attributes' do

      subject { post :create, post: attributes_for(:post) }

      it 'creates a new post' do
        expect { subject }.to change(Post, :count).by(1)
      end

      it { is_expected.to redirect_to blogs_root_path }
    end

    context 'with invalid attributes' do

      subject { post :create, post: attributes_for(:post).except(:title) }

      it 'doesn\'t create post' do
        expect { subject }.to_not change(Post, :count)
      end

      it { is_expected.to render_template :new }
    end
  end

  describe '#show' do

    before { get :show, id: saved_post }

    it 'assigns @post' do
      expect(assigns(:post)).to eq(saved_post)
    end

    context 'when rendering views' do
      render_views

      it { is_expected.to render_template :show }
    end
  end

  describe '#edit' do

    context 'when post exists' do
      
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

        before { sign_in user }

        it 'renders #index' do
          expect(subject).to render_template :index
        end
      end
    end

    context 'when post does\'t exist' do
      before { sign_in user }
      
      subject { get :edit, id: Faker::Number.number(10) }

      it { is_expected.to render_template :index }
    end
  end

  describe '#update' do

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

  describe '#destroy' do

    context 'when post exists' do

      subject { delete :destroy, :id => saved_post }

      context 'when current user matches to post' do

        before { sign_in saved_post.user }

        it 'destroys' do
          expect { subject }.to change(Post, :count).by(-1)
        end

        it { is_expected.to redirect_to blogs_root_path }
      end

      context 'when current user doesn\'t match to post' do

        before { sign_in user }

        it 'doesn\'t destroy' do

          expect { subject }.to_not change(Post, :count)
        end

        it { is_expected.to redirect_to blogs_root_path }
      end
    end

    context 'when post doesn\'t exist' do
      
      before { sign_in user }

      subject { delete :destroy, :id => saved_post }

      it { is_expected.to redirect_to blogs_root_path }
    end
  end
end
