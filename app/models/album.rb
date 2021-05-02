require "base64"
class Album < ApplicationRecord
    validates :name, presence: true
    validates :genre, presence: true
    validates :album_id, uniqueness: true
end
