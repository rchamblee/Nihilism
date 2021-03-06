class IndexController < ApplicationController
	def index
		@reply_to = params[:id]
		@heading_image = Dir.glob("#{Rails.root}/app/assets/images/heading/*").sample.split("#{Rails.root}/app/assets/images/")[1] #Dir.glob("*")
	end

	def post
		begin
			if simple_captcha_valid?
				msg = params.require(:msg)
				if msg.length > 8192
					@error_msg = "Bad request: Post too long"
					render status: :bad_request
				else
					post_id = Post.reply(params.require(:msg), params[:parent]).to_s
					redirect_to "/"+post_id+"#reply-"+post_id
				end
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
