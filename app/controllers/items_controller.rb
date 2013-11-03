class ItemsController < ApplicationController
      before_filter :authenticate_user!, :except => [:home, :show, :search]

  def search
    if params[:keyword].nil?
      @items = Item.select(:id).where({category: params[:category_query]})
    else
      if params[:category_query].eql?("All")
        @items = Item.select(:id).where({title: params[:keyword]})
      else
        @items = Item.select(:id).where({category: params[:category_query], title: params[:keyword]})
      end
    end
    redirect_to root_path, :flash => { :query_result => @items }
  end


  def home
    if !flash[:query_result].nil?
      @find_items = Item.where('id = ?', flash[:query_result])
      flash[:query_result] = nil
    else
      @items = Item.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end


  # GET /items
  # GET /items.json
  def index
    @user=current_user
    @items = Item.find_all_by_user_id(current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    cookies.permanent[:remember_item_token] = @item.id
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])
    @item.user_id = current_user.id


    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end
end
