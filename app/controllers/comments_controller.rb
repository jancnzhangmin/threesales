class CommentsController < ApplicationController
  before_action :authenticate_role
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :publecomm, :publedel]
  before_action :set_seller, only: [:show, :edit, :update, :destroy, :publecomm, :publedel]
  before_action :set_article, only: [:show, :edit, :update, :destroy, :publecomm, :publedel]
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    debugger
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    @comment.fabulous = 1
    @comment.save
  end

  def publecomm
    @comment.fabulous = 1
    @comment.save
    #redirect_to :back
    redirect_to [@seller,@article]
    #format.html { redirect_to seller_article_path([@seller,@article]) , notice: 'Comment was successfully created.' }
  end

  def publedel
    @comment.destroy
    redirect_to [@seller,@article]
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_seller
      @seller = Seller.find(params[:seller_id])
    end

    def set_article
      @article = Article.find(params[:article_id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:article_id, :openid, :content, :fabulous)
    end
end
