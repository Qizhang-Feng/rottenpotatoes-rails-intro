class Movie < ActiveRecord::Base

    def self.with_ratings(ratings_list)
        if ratings_list == nil or ratings_list == []

            return Movie.all
        else
            return Movie.where(rating: ratings_list)
        end

    end

end
