class Session < ApplicationRecord
  belongs_to :run
  belongs_to :program
end
