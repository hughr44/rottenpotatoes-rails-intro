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
    
    @all_ratings = ['G','PG','PG-13','R']
    
    session[:ratings] = session[:ratings] || {'G'=>'', 'PG'=>'', 'PG-13'=>'', 'R'=>''}
    session[:ratings] = params[:ratings] || session[:ratings]
    
    @sort = params[:sort] || session[:sort]
    session[:sort] = @sort
    
    #@movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
    
    #if !(params[:ratings].nil?)
    #  session[:ratings] = params[:ratings]
    #end
    
    #if !(params[:sort].nil?)
    #  session[:sort] = params[:sort]
    #end
    
    if(params[:sort].nil? and !(session[:sort].nil?)) or (params[:ratings].nil? and !(session[:ratings].nil?))
      flash.keep
      redirect_to movies_path(sort: session[:sort],ratings: session[:ratings])
    elsif !params[:sort].nil? || params[:ratings].nil?
      if !params[:ratings].nil?
        @movies = Movie.where(rating: params[:ratings].keys).order(session[:sort])
      else
        @movies = Movie.all.order(session[:sort])
      end
    # this causing redirect problem when heroku starts up???
    #elsif !session[:ratings].nil? || !session[:sort].nil?
    #  flash.keep
    #  redirect_to movies_path(sort: session[:sort],ratings: session[:ratings])
    else
      @movies = Movie.all
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

end
