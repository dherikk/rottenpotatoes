class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @hehe = params
      if(!(@hehe.has_key?(:sort) || @hehe.has_key?(:ratings)))
        if(session.has_key?(:current_user_id))
          @hehe[:ratings] = session[:current_user_id]
        end
      end
      @sort_number = @hehe[:sort].nil? ? (@hehe[:ratings].nil? ? 1 : @hehe[:ratings].values[0]) : @hehe[:sort]
      @all_ratings = Movie.all_ratings
      @initial = @all_ratings.to_h{|i| [i, @sort_number]}
      @ratings_to_show = @hehe[:ratings] || @initial
      @movies = Movie.with_ratings(@ratings_to_show.keys, @sort_number)
      @movie_title_class = @sort_number == "2" ? "bg-warning hilite" : "movie_title"
      @movie_release_class = @sort_number == "3" ? "bg-warning hilite" : "movie_rating"
      @new_hash = @ratings_to_show.map { |k, v| [k, @sort_number] }.to_h
      session[:current_user_id] = @new_hash
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