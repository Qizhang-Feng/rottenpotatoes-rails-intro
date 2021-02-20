class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all
    if request.path == '/'
      reset_session
    end
    
    params[:ratings] = params[:ratings].nil? ? session[:ratings] : params[:ratings]
    params[:sort] = params[:sort].nil? ? session[:sort] : params[:sort]
    
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @ratings_to_show = params[:ratings] == nil ? @all_ratings : params[:ratings].keys
    @movies = Movie.with_ratings(@ratings_to_show)
    # if sort
    if params[:sort] != nil
      @movies = @movies.order(params[:sort])
    end
    
    # save all setting in session
    session[:ratings] = params[:ratings]
    session[:sort] = params[:sort]
    puts params[:sort]
    
    if params[:sort] == "title"
      @css_title = "hilite bg-warning"
    elsif params[:sort] == "release_date"
      @css_release_date = "hilite bg-warning"
    end
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
