class IndexController < ApplicationController
	def index
		@reply_to = params[:id]
	end
	
	def post
		post_id = Post.create(parent: params[:parent], message: params.require(:msg)).id.to_s
		redirect_to "/"+post_id+"#reply-"+post_id
	end
end
