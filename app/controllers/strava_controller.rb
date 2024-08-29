require 'rest-client'

class StravaController < ApplicationController
  def connect
    @path = "https://www.strava.com/oauth/authorize?client_id=#{ENV.fetch('STRAVA_CLIENT_ID')}&response_type=code&redirect_uri=#{Rails.configuration.base_url}#{strava_callback_path}&approval_prompt=force&scope=activity:read_all"
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
  rescue StandardError => e
    # Handle any errors during the OAuth process
    redirect_to strava_connect_path, alert: "Erreur: #{e.message}"
  end

  def sync
    refresh_strava_token if current_user.strava_token_expired?
    url = "https://www.strava.com/api/v3/athlete/activities"
    request = RestClient.get(url, { 'Authorization' => "Bearer #{current_user.strava_access_token}" })
    response = JSON.parse(request.body)
    run_activities = response.select { |run| run['type'] = 'Run' }
    # for each of the run activities
    # get the running session associated with the activity date
    # if running session is not nil then
    # get the run associated with the running session
    # update the run : real total km, real total time and real avg pace
    # redirect back or to home page
    run_activities.each do |activity|
      activity_date = activity['start_date'].to_date
      running_session = RunningSession.find_by(date: activity_date)
      unless running_session.nil?
        run = running_session.run
        run.update!(
          real_total_km_ran: (activity['distance']/1000).round(2),
          real_total_time_ran: (activity['moving_time'] / 60).round(2),
          real_avg_pace_ran: (60 / (activity['average_speed'] * 3.6)).round(2),
          status: "completed"
        )
      end
    end
    redirect_back_or_to home_path, notice: 'Synchronisation avec Strava réussie'
  rescue StandardError => e
    redirect_back_or_to home_path, alert: "Erreur: #{e.message}"
  end
end
