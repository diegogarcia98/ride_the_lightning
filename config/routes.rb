Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #ARTISTS_CONTROLLER
  post 'artists', to: 'artists#create'
  get 'artists', to: 'artists#index'
  get 'artists/:artist_id', to: 'artists#show'
  put 'artists/:artist_id/albums/play', to: 'artists#play_artist_tracks' 
  delete 'artists/:artist_id', to: 'artists#delete' ###

  #ALBUMS_CONTROLLER
  post 'artists/:artist_id/albums', to: 'albums#create'
  get 'albums', to: 'albums#index'
  get 'albums/:album_id', to: 'albums#show'
  get 'artists/:artist_id/albums', to:'albums#albums_artist'
  put 'albums/:album_id/tracks/play', to: 'albums#play_album_tracks' 
  delete 'albums/:album_id', to: 'albums#delete' ###

  #TRACKS_CONTROLLER
  post 'albums/:album_id/tracks', to: 'tracks#create'
  get 'tracks', to: 'tracks#index'
  get 'tracks/:track_id', to: 'tracks#show'
  get 'artists/:artist_id/tracks', to: 'tracks#tracks_artist' 
  get 'albums/:album_id/tracks', to:'tracks#tracks_album'
  put 'tracks/:track_id/play', to: 'tracks#play_track' 
  delete 'tracks/:track_id', to: 'tracks#delete' ###



  get "*missing" ,to: 'artists#method_not_allowed'
  post "*missing" ,to: 'artists#method_not_allowed'
  put  "*missing" ,to: 'artists#method_not_allowed'
  delete "*missing" ,to: 'artists#method_not_allowed'
end
