class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    if sort == "title"
      @title_header = "hilite"
    elsif sort == "release_date"
      @release_header = "hilite"
    end
    
    @all_ratings = Movie.uniq.pluck(:rating)
    @sel_ratings = params[:ratings] || session[:ratings] || {}
    
# If no sel_ratings, check all the ratings. (Done using hashmap)
    if @sel_ratings == {}
      @all_ratings.each do |rating|
        @sel_ratings[rating] = 1
      end
    end

# For storing the previous sort/sel, when changing other activities    
    if params[:ratings] != session[:ratings] or params[:sort] != session[:sort]
      session[:sort] = sort
      session[:ratings] = @sel_ratings
      redirect_to :sort => sort, :ratings => @sel_ratings and return
    end
    
    #@movies = Movie.order(params[:sort])
    @movies = Movie.where(rating: @sel_ratings.keys).order(params[:sort])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
