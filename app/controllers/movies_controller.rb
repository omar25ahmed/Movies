class MoviesController < ApplicationController
  def index
    @movies = Movie.by_actor(params[:query]).sort_by_revision
  end
end
