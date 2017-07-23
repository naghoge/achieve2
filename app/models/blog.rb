class Blog < ActiveRecord::Base
    # self.site = "https://benefique-madame-61953.herokuapp.com"
    validates :title, presence: true
    validates :content, presence: true
    belongs_to :user
end