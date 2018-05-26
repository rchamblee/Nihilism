class IndexController < ApplicationController
	def index
	end
	
	def post
		redirect_to "/#"+Post.create(message: params.require(:msg)).id.to_s
	end
end
