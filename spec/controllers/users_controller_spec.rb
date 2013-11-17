require 'spec_helper'

describe UsersController do
  before (:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @item = FactoryGirl.create(:item)
    sign_in @user
  end

  describe "current user" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end

  end

  #describe "GET index" do
  #  it "assigns @users" do
  #    user = User.create
  #    get :show
  #    expect(assigns(:users)).to eq([user])
  #  end
  #
  #
  #end

  describe "GET #edit" do
    it "assigns signed in user" do
      # user = User.create! valid_attributes
      get :edit, {:id => @user.to_param}
      assigns(:user).should eq(@user)
    end
  end

  describe "Show user page should display the item selling, sold and bought" do
    it "should show the items being sold by user" do
         #@user.id = 1
         get :show, {:id => @user.to_param}
         @items= Item.where(:user_id => @user.id).where("total_quantity <> quantity")
         #@items= Item.find_all_by_user_id(:id).where("total_quantity <> quantity")
        #expect(assigns(:items[2])).to eq  @items
         expect(assigns(:@items[2])).to eq  @items
       # flash[:alert].should eql("")
    end

    it "should show the items selling by user" do
      get :show, {:id => @user.to_param}
      @items= Item.where(:user_id => @user.id).where("quantity > 0")
      expect(assigns(:@items[1])).to eq  @items

    end

    #it "should show the items being bought by user" do
     # get :show, {:id => @user.to_param}
    #  @items= Item.find_all_by_user_id(:id)
     # expect(assigns(:items_bought)).not_to eq  @items
    #end

  end



  #describe "After Editing Profile, user is redirected to Profile page" do
  # it "when user clicks the edit profile page" do
  #   post :update
  #  expect(response).to redirect_to :id
  # end
  #end


  # The test below makes no sense after the code is refactored.
=begin
  describe "GET show" do
    it "assigns the current_user as @user" do
      get :show, {:id => @user.to_param}
      assigns(:user).should eq(@user)
    end
  end
=end
  context "Valid attributes" do
    it "assigns the signed in user as @user" do
      put :update, {:id => @user.to_param}
      assigns(:user).should eq(@user)
    end

    it "User should be redirected to profile page after updating profile page" do
      put :update, {:id => @user.to_param}
      response.should redirect_to(@user)
    end

    it "signs a users out" do
      sign_out @user
      subject.current_user.should be_nil
    end
  end






end


