class User < ApplicationRecord
  # attr_accessor :strava_refresh_token
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :programs

  validates :first_name, presence: true, on: :update
  validates :weight, presence: true, on: :update
  validates :age, presence: true, on: :update

  def strava_token_expired?
    strava_token_expires_at < Time.now
  end

  # Method to refresh the Strava token using the refresh token
  def refresh_strava_token
    response = RestClient.post('https://www.strava.com/oauth/token',
    { client_id: ENV.fetch('STRAVA_CLIENT_ID'),
      client_secret: ENV.fetch('STRAVA_CLIENT_SECRET'),
      refresh_token: strava_refresh_token,
      grant_type: 'refresh_token' })

    tokens = JSON.parse(response.body)
    update(
      strava_access_token: tokens['access_token'],
      strava_refresh_token: tokens['refresh_token'],
      strava_token_expires_at: Time.at(tokens['expires_at'])
    )
  end
end
