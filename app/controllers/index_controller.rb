class IndexController < ApplicationController
	def index
		@reply_to = params[:id]
	end
	
	def post
		post_id = Post.reply(params.require(:msg),params[:parent]).to_s
		redirect_to "/"+post_id+"#reply-"+post_id
	end
end
