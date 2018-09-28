class Movie < ActiveRecord::Base
    def self.all_ratings
       ['PG', 'G', 'R', 'PG-13', 'NC-17'] 
    end
end
