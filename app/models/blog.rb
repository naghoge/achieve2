class Blog < ActiveResource::Base
    self.site = "https://tranquil-sea-23643.herokuapp.com"
    validates :title, presence: true
    validates :content, presence: true
    belongs_to :user
end