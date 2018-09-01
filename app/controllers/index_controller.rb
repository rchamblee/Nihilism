class IndexController < ApplicationController
	def index
		@reply_to = params[:id]
	end

	def post
		begin
			if simple_captcha_valid?
				post_id = Post.reply(params.require(:msg),params[:parent]).to_s
				redirect_to "/"+post_id+"#reply-"+post_id
			else
				@error_msg = "Bad request: Invalid CAPTCHA"
				render status: :bad_request
			end
		rescue ActionController::ParameterMissing
			@error_msg = "Bad request: Cannot post empty message"
			render status: :bad_request
		rescue ActiveRecord::RecordNotFound
			@error_msg = "Bad request: Cannot reply to non-existent post"
			render status: :bad_request
		end
	end
end
