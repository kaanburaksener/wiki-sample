class ArticlesController < ApplicationController
  before_action :find_article, only: [:destroy, :edit ,:show, :update]
  before_action :get_all_articles, only: [:index]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    if params[:category].blank?
      get_all_articles
    else
      @category_id = Category.find_by(name: params[:category]).id
      get_articles_by_category(@category_id)
    end
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def destroy
    @article.destroy
    redirect_to root_path
  end

  def edit
  end

  def new
    @article = current_user.articles.build
  end

  def show
  end

  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  private
  def article_params
    params.require(:article).permit(:title, :content, :category_id)
  end

  def find_article
    @article = Article.find(params[:id])
  end

  def get_articles_by_category(category_id)
    @articles = Article.where(:category_id => category_id).order("created_at DESC")
  end

  def get_all_articles
    @articles = Article.all.order("created_at DESC")
  end
end
