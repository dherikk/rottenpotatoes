class Movie < ActiveRecord::Base

  def self.all_ratings
    Movie.distinct.pluck(:rating)
  end
  def self.with_ratings(ratings_list, order)
    if order == "none"
      return ratings_list.empty? ? Movie.all : Movie.where(rating: [ratings_list])
    elsif order == "title"
      return ratings_list.empty? ? Movie.all.order("title") : Movie.where(rating: [ratings_list]).order("title")
    else
      return ratings_list.empty? ? Movie.all.order("release_date") : Movie.where(rating: [ratings_list]).order("release_date")
    end
  end
end