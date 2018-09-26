
class ArticlesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  
  def index
   articles = [];
   due = 0;
   overdue = 0;
   Article.all.order("created_at ASC").each do |article| 
     if (Time.now).to_date > article.published_date.to_date
        due = ((Time.now).to_date - article.published_date.to_date).to_i
        # puts "due ==#{due}===" 
        article_json = article.to_json
        articles << JSON.parse(article_json).merge!(:due => due)
     else (Time.now).to_date < article.published_date.to_date
          overdue = (article.published_date.to_date - (Time.now).to_date).to_i
          # puts "overdue ==#{overdue}==="
          article_json = article.to_json
          articles << JSON.parse(article_json).merge!(:overdue => overdue)
     end
    end 
      render :json => {articles: articles, count: Article.all.count, overdue: Article.where('published_date > ?', Time.now).count} 
   end

   def search
    if params[:search]
      articles = [];
      due = 0;
      overdue = 0;
      Article.search(params[:search]).order("created_at ASC").each do |article| 
        if (Time.now).to_date > article.published_date.to_date
            due = ((Time.now).to_date - article.published_date.to_date).to_i
            # puts "due ==#{due}===" 
            article_json = article.to_json
            articles << JSON.parse(article_json).merge!(:due => due)
        else (Time.now).to_date < article.published_date.to_date
              overdue = (article.published_date.to_date - (Time.now).to_date).to_i
              # puts "overdue ==#{overdue}==="
              article_json = article.to_json
              articles << JSON.parse(article_json).merge!(:overdue => overdue)
        end
        end 
          render :json => {articles: articles, count: Article.all.count, overdue: Article.where('published_date > ?', Time.now).count} 
        else
          articles = Article.all.order("created_at DESC")
          render :json => {articles: articles}
      end
   end  
 
  def show
    @article = Article.find(params[:id])
  end
 
  def new
    @article = Article.new
  end
 
  def edit
    @article = Article.find(params[:id])
  end
 
  # def create
  #   @article = Article.new(article_params)
 
  #   if @article.save
  #     redirect_to @article
  #   else
  #     render 'new'
  #   end
  # end

  def create
    puts "#{params.inspect}"
    Article.create(title: params[:title], body: params[:body], published_date: params[:published_date])
    render :json => {status: true}
  end
 
  def update
    @article = Article.find(params[:id])
 
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end
 
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
 
    redirect_to articles_path
  end
 
  # private
  #   def article_params
  #     params.require(:article).permit(:title, :body, :published_date)
  #   end
end