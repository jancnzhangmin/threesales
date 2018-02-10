class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :set_seller,only: [:index, :new, :create, :show, :edit, :update, :destroy]

  def index
    @articles = @seller.articles
  end

  def show
  end

  def new
    @article = Article.new
    @article.pubiletime = Time.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    @article.seller_id = @seller.id
    respond_to do |format|
      if @article.save
        format.html { redirect_to seller_articles_path, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to seller_articles_path, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to seller_articles_path, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seller
      @seller = Seller.find(params[:seller_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :writer, :pubiletime, :number, :content)
    end
end
