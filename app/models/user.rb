class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :programs

  validates :first_name, presence: true, on: :update
  validates :weight, presence: true, on: :update
  validates :age, presence: true, on: :update
end
