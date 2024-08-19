class Session < ApplicationRecord
  belongs_to :run
  belongs_to :program

  validates :date, presence: true
end
