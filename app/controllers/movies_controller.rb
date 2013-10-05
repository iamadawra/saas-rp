class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort = params[:sort]
    @all_ratings = Movie.allRatings
    session[:sort] = @sort unless (@sort.nil?)
    session[:ratings] = params[:ratings] unless (params[:ratings].nil?)
    if (session[:ratings])
      @movies = Movie.find(:all, :order => session[:sort], :conditions => {:rating => session[:ratings].keys})
      @filter_ratings = session[:ratings].keys
    else
      @movies = Movie.all(:order => session[:sort])
      @filter_ratings = @all_ratings
      @filter_hash = {}
      @filter_ratings.each do |word|
        @filter_hash[word] = word
      end
      session[:ratings] = @filter_hash
    end
    if (session[:sort]!=params[:sort] || session[:ratings] != params[:ratings])
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
