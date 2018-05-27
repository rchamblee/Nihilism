class IndexController < ApplicationController
	def index
		@reply_to = params[:id]
	end
	
	def post
		begin
			post_id = Post.reply(params.require(:msg),params[:parent]).to_s
			redirect_to "/"+post_id+"#reply-"+post_id
		rescue ActionController::ParameterMissing
			@error_msg = "Bad request: Cannot post empty message"
			render status: :bad_request
		end
	end
end
