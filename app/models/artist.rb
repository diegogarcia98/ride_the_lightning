class Artist < ApplicationRecord
    validates :name, presence: true
    validates :age, presence: true, numericality: { only_integer: true }
    validates :artist_id, uniqueness: true
end
