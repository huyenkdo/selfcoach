require 'rest-client'

class StravaController < ApplicationController
  def connect
    @path = "https://www.strava.com/oauth/authorize?client_id=#{ENV.fetch('STRAVA_CLIENT_ID')}&response_type=code&redirect_uri=http://localhost:3000#{strava_callback_path}&approval_prompt=force&scope=activity:read_all"
  end

  def callback
    # Step 1: Capture the authorization code from the URL
    authorization_code = params[:code]

    # Step 2: Exchange the authorization code for an access token
    response = RestClient.post('https://www.strava.com/oauth/token',
      { client_id: ENV.fetch('STRAVA_CLIENT_ID'),
        client_secret: ENV.fetch('STRAVA_CLIENT_SECRET'),
        code: authorization_code,
        grant_type: 'authorization_code' })

    # Step 3: Parse the response to get the tokens
    tokens = JSON.parse(response.body)
    access_token = tokens['access_token']
    refresh_token = tokens['refresh_token']
    expires_at = tokens['expires_at']
    first_name = tokens['athlete']['firstname']
    weight = tokens['athlete']['weight']
    weight = 0 if weight.nil?
    age = 0

    # Step 4: Store the tokens in the session or database (depending on your app’s architecture)
    current_user.update!(
      strava_access_token: access_token,
      strava_refresh_token: refresh_token,
      strava_token_expires_at: Time.at(expires_at),
      first_name:,
      weight:,
      age:
    )

    # Step 5: Redirect the user to a relevant page in your app
    redirect_to profile_path, notice: 'Ton compte Strava a bien été connecté!'
  rescue => e
    # Handle any errors during the OAuth process
    redirect_to root_path, alert: "Erreur: #{e.message}"
  end
end
