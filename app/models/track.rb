require "base64"
class Track < ApplicationRecord
    validates :name, presence: true
    validates :duration, presence: true, numericality: { only_float: true }
    validates :track_id, uniqueness: true
end
