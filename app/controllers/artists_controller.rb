require "base64"
class ArtistsController < ApplicationController
    def index
        artists = Artist.all
        artists_filter = []
        artists.each do |artist|
            new_format = {artist_id: artist["artist_id"], name: artist["name"], age: artist["age"], 
            albums: artist["albums"],tracks:artist["tracks"],self: artist["self"]}
            artists_filter.append(new_format)
        end
        render json: artists_filter, status: :ok
    end
    
    
    def create
        artist = Artist.new(artist_params)

        if artist.save
            render json: {artist_id: artist["artist_id"], name: artist["name"], age: artist["age"], 
            albums: artist["albums"],tracks:artist["tracks"],self: artist["self"]}, status: 201

        else
            error = artist.errors
            error = error.keys.first
            error = error.to_s
            if error == "age" or error == "name"
                render json: {status: "400", message: "Faltan datos y/o los formatos especificados de los atributos no son correctos"}, status: 400
            elsif error == "artist_id"
                
                existente =Artist.find_by(artist_id: artist["artist_id"])
                render json: {artist_id: existente["artist_id"], name: existente["name"], age: existente["age"], 
                albums: existente["albums"],tracks: existente["tracks"], 
                self: existente["self"]}, status: 409                
            else
                render json: {status: "405", message: error}, status: 405
            end    
            
        end
    end
   
    def show
        artist =Artist.find_by(artist_id: params[:artist_id])
        if artist == nil
            render json: {status: "404", message: "Artista no existe"}, status: 404
        else
            render json: {artist_id: artist["artist_id"], name: artist["name"], age: artist["age"], 
                albums: artist["albums"],tracks: artist["tracks"], 
                self: artist["self"]}, status: 200
        end
    end
    
    
    def play_artist_tracks
        artist =Artist.find_by(artist_id: params[:artist_id])
        if artist == nil
            render json: {status: "404", message: "Artista no existe"}, status: 404
        else
            tracks = Track.where("artist": artist["self"])
            tracks.each do |track|
                contador = track["times_played"]+1
                track.update(times_played: contador)
            end
            tracks_filter = []
            tracks.each do |track|
                new_format = {track_id: track["track_id"], name: track["name"], duration: track["duration"], 
                times_played: track["times_played"],artist: track["artist"],album:track["album"],self: track["self"]}
                tracks_filter.append(new_format)
            end
            render json: tracks_filter, status: 200
            
        end
    end
    
    def delete
        artist =Artist.find_by(artist_id: params[:artist_id])
        if artist == nil
            render json: {status: "404", message: "Álbum no existe"}, status: 404
        else
            tracks = Track.where(artist: artist["self"])
            albums = Album.where(artist: artist["self"])
            tracks.each do |track|
                track.destroy
            end
            albums.each do |album|
                album.destroy
            end
            artist.destroy
            render json: {status: "204 No Content", message: "Canción Eliminada"}, status: 204
        end
    end
    

    def method_not_allowed
        render json: {status: "405 Method Not Allowed"}, status: 405
    end 
    
    
    
    
    
    private

    def artist_params
        
        codificado = Base64.encode64(params[:name])
        codificado = codificado.gsub "\n", ""
        name_codificado = codificado
        if codificado.length() > 22
            name_codificado = ""
            i=0
            while i < 22 do 
                name_codificado = name_codificado + codificado[i]
                i = i+1
            end
        end
        artist_params = {artist_id: name_codificado, name: params[:name], age: params[:age],albums: "http://localhost:3000/artists/"+name_codificado+"/albums",
        tracks: "http://localhost:3000/artists/"+name_codificado+"/tracks",self: "http://localhost:3000/artists/"+name_codificado}
    end   

end