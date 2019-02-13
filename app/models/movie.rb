class Movie < ActiveRecord::Base
    def self.get_ratings
    temp = Array.new
    self.select("rating").uniq.each{|m| temp.push(m.rating)}
    temp.sort.uniq
  end
end
