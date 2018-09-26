
class Article < ApplicationRecord
  validates :title, presence: true,
                    length: { minimum: 4 }

  def self.search(search)
    where("title LIKE ?", "%#{search}%") 
  end

end