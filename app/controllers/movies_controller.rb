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
    #************Part2************#
    # @movies = Movie.all.order(params[:sortParams])
    # if params[:ratings]
    #   @movies = Movie.where(:rating => params[:ratings].keys).order(params[:sortParams])
    # end
    # @all_ratings = Movie.get_ratings
    # @sortBy = params[:sortParams]
    # @ratingBy = params[:ratings]? params[:ratings] : Hash.new
    
    #************Part3************#
    if params[:sortParams]
      @sortBy = params[:sortParams]
      session[:sortParams] = params[:sortParams]
    elsif session[:sortParams]
      @sortBy = session[:sortParams]
      redirect = true
    else
      @sortBy = nil
      session[:sortParams] = nil
    end

    if params[:ratings]
      @ratingBy = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      if params[:commit] == "Refresh"
        @ratingBy = nil
        session[:ratings] = nil
      else
        @ratingBy = session[:ratings]
        redirect = true
      end
    else
      @ratingBy = nil
      session[:ratings] = nil
    end
    
    if redirect
      flash.keep
      redirect_to movies_path :sortParams => @sortBy, :ratings => @ratingBy
    end
    
    @movies = Movie.all.order(@sortBy)
    if params[:ratings]
      @movies = Movie.where(:rating => @ratingBy.keys).order(@sortBy)
    end
    @all_ratings = Movie.get_ratings
    @sortBy = params[:sortParams]
    @ratingBy = params[:ratings]? params[:ratings] : Hash.new
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
