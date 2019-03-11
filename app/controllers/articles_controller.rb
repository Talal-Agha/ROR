class ArticlesController < ApplicationController

  def index
    @articles = Article.joins(:user)
  end
  
  def new
    if session[:user_id]
      @article = Article.new
    else
    redirect_to_login
    end
  end

  def show
    @article = Article.find(params[:id])
    @user = User.find(@article.user_id);
  end

  def edit
    @article = Article.find(params[:id])
    if session[:user_id] != @article.user_id
    redirect_to_login
    end
  end

  def create
    if !session[:user_id]
      redirect_to login_url
    else
    @article = Article.new(article_params) 
    @article.user_id = session[:user_id]

    if @article.save
        redirect_to @article
    else
        render 'new'
    end
  end
  end

  def update
    @article = Article.find(params[:id])
    if @article.user_id != session[:user_id]
    redirect_to_login
    else

    if @article.update(article_params)
        redirect_to @article
    else
        render 'edit'
    end
  end
  end

  def destroy
    @article = Article.find(params[:id])
     if @article.user_id != session[:user_id]
      redirect_to_login
    else
      @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article is successfully deleted.' }
    end
  end
  end

  private
  def article_params
    params.require(:article).permit(:title, :text)
  end

  private
  def redirect_to_login
    respond_to do |format|
      format.html { redirect_to login_url, alert: 'You are not authorized.' }
    end
  end

end
