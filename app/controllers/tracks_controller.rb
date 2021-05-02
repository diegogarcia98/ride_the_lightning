require "base64"
class TracksController < ApplicationController
    def index
        tracks = Track.all
        tracks_filter = []
        tracks.each do |track|
            new_format = {track_id: track["track_id"], name: track["name"], duration: track["duration"], 
            times_played: track["times_played"],artist: track["artist"],album:track["album"],self: track["self"]}
            tracks_filter.append(new_format)
        end
        render json: tracks_filter, status: :ok
    end
    
    
    
    
    def create
        album = Album.find_by(album_id: params[:album_id])
        if album == nil
            render json: {message: "No existe álbum. No se puede agregar canción"}, status: 422
        else
            track = Track.new(track_params)

            if track.save
                render json: {track_id: track["track_id"], name: track["name"], duration: track["duration"], 
                times_played: track["times_played"], artist: track["artist"],album: track["album"],self: track["self"]}, status: 201

            else
                error = track.errors
                error = error.keys.first
                error = error.to_s
                if error == "duration" or error == "name"
                    render json: {status: "400", message: "Faltan datos y/o los formatos especificados de los atributos no son correctos"}, status: 400
                elsif error == "track_id"
                    
                    existente =Track.find_by(track_id: track["track_id"])
                    render json: {track_id: existente["track_id"], name: existente["name"], duration: existente["duration"], 
                    times_played: existente["times_played"],artist: existente["artist"],album:existente["album"],self: existente["self"]}, status: 409                
                else
                    render json: {status: "405", message: error}, status: 405
                end    
                
            end
        end
    end

  
    def show
        track =Track.find_by(track_id: params[:track_id])
        if track == nil
            render json: {status: "404", message: "Canción no existe"}, status: 404
        else
            render json: {track_id: track["track_id"], name: track["name"], duration: track["duration"], 
            times_played: track["times_played"], artist: track["artist"],album: track["album"],self: track["self"]}, status: 200
        end
    end
    
    
    def tracks_artist
        artist = Artist.find_by(artist_id: params[:artist_id])
        if artist == nil
            render json: {status: "404", message: "Artista no existe"}, status: 404
        else
            artist_url = artist["self"]
            tracks = Track.all
            tracks_artist=[]
            tracks.each do |track|
                if track["artist"]==artist_url
                    tracks_filter={track_id: track["track_id"], name: track["name"], duration: track["duration"], 
                    times_played: track["times_played"],artist: track["artist"],album: track["album"],self: track["self"]}
                    tracks_artist.append(tracks_filter)
                end
            end
            render json: tracks_artist , status:200
        end
    end

    def tracks_album
        album = Album.find_by(album_id: params[:album_id])
        if album == nil
            render json: {status: "404", message: "Álbum no existe"}, status: 404
        else
            album_url = album["self"]
            tracks = Track.all
            tracks_album=[]
            tracks.each do |track|
                if track["album"]==album_url
                    tracks_filter={track_id: track["track_id"], name: track["name"], duration: track["duration"], 
                    times_played: track["times_played"],artist: track["artist"],album: track["album"],self: track["self"]}
                    tracks_album.append(tracks_filter)
                end
            end
            render json: tracks_album , status:200
        end
    end
    
    
    def play_track
        track =Track.find_by(track_id: params[:track_id])
        if track == nil
            render json: {status: "404", message: "Canción no existe"}, status: 404
        else
            contador = track["times_played"]+1
            track.update(times_played: contador)
            track_filter = {track_id: track["track_id"], name: track["name"], duration: track["duration"], 
            times_played: track["times_played"],artist: track["artist"],album:track["album"],self: track["self"]}
            
            render json: track_filter, status: 200
            
        end
    end
    
    def delete
        track = Track.find_by(track_id: params[:track_id])
        if track == nil
            render json: {status: "404", message: "Canción no existe"}, status: 404
        else
            track.destroy
            render json: {status: "204 No Content", message: "Canción Eliminada"}, status: 204
        end
    end
    
    
    
    
    private

    def track_params
        album = Album.find_by(album_id: params[:album_id])
        codificado = Base64.encode64(params[:name] +":"+ album["album_id"])
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
        track_params = {track_id: name_codificado, name: params[:name], duration: params[:duration],times_played:0,
        artist: album["artist"], album: "http://localhost:3000/albums/"+album["album_id"],self: "http://localhost:3000/tracks/"+name_codificado}
    end   
   
end