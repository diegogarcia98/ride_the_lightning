require "base64"
class AlbumsController < ApplicationController

    def index
        albums = Album.all
        albums_filter = []
        albums.each do |album|
            new_format = {album_id: album["album_id"], name: album["name"], genre: album["genre"], 
            artist: album["artist"],tracks:album["tracks"],self: album["self"]}
            albums_filter.append(new_format)
        end
        render json: albums_filter, status: 200
    end
    
    
    
    def create
        artist = Artist.find_by(artist_id: params[:artist_id])
        if artist == nil
            render json: {message: "No existe artista. No se puede agregar álbum"}, status: 422
        else
            album = Album.new(album_params)

            if album.save
                render json: {album_id: album["album_id"], name: album["name"], genre: album["genre"], 
                artist: album["artist"],tracks:album["tracks"],self: album["self"]}, status: 201

            else
                error = album.errors
                error = error.keys.first
                error = error.to_s
                if error == "genre" or error == "name"
                    render json: {status: "400", message: "Faltan datos y/o los formatos especificados de los atributos no son correctos"}, status: 400
                elsif error == "album_id"
                    
                    existente =Album.find_by(album_id: album["album_id"])
                    render json: {album_id: existente["album_id"], name: existente["name"], genre: existente["genre"], 
                    artist: existente["artist"],tracks:existente["tracks"],self: existente["self"]}, status: 409                
                else
                    render json: {status: "405", message: error}, status: 405
                end    
                
            end
        end
    end

    def show
        album =Album.find_by(album_id: params[:album_id])
        if album == nil
            render json: {status: "404", message: "Album no existe"}, status: 404
        else
            render json: {album_id: album["album_id"], name: album["name"], genre: album["genre"], 
            artist: album["artist"],tracks:album["tracks"],self: album["self"]}, status: 200
        end
    end
    
    
    
    def albums_artist
        artist = Artist.find_by(artist_id: params[:artist_id])
        if artist == nil
            render json: {status: "404", message: "Artista no existe"}, status: 404
        else
            artist_url = artist["self"]
            albums = Album.all
            albums_artist=[]
            albums.each do |album|
                if album["artist"]==artist_url
                    albums_filter={album_id: album["album_id"], name: album["name"], genre: album["genre"], 
                    artist: album["artist"],tracks:album["tracks"],self: album["self"]}
                    albums_artist.append(albums_filter)
                end
            end
            render json: albums_artist , status:200
        end
    end
    
    
    def play_album_tracks
        album =Album.find_by(album_id: params[:album_id])
        if album == nil
            render json: {status: "404", message: "Álbum no existe"}, status: 404
        else
            tracks = Track.where("album": album["self"])
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
        album =Album.find_by(album_id: params[:album_id])
        if album == nil
            render json: {status: "404", message: "Álbum no existe"}, status: 404
        else
            tracks = Track.where(album: album["self"])
            tracks.each do |track|
                track.destroy
            end
            album.destroy
            render json: {status: "204 No Content", message: "Canción Eliminada"}, status: 204
        end
    end
    
    
    private

    def album_params
        artist = Artist.find_by(artist_id: params[:artist_id])
        codificado = Base64.encode64(params[:name] +":"+ artist["artist_id"])
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
        artist_params = {album_id: name_codificado, name: params[:name], genre: params[:genre],artist: "http://localhost:3000/artists/"+params[:artist_id],
        tracks: "http://localhost:3000/albums/"+name_codificado+"/tracks",self: "http://localhost:3000/albums/"+name_codificado}
    end   
end