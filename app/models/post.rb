class Post < ActiveRecord::Base
	validates :message, :presence => true
end
