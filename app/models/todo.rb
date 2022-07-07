class Todo < ApplicationRecord
    validates :title, presence: true
    validates :body, presence: true
    belongs_to :user
end
