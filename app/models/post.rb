class Post < ActiveRecord::Base
	validates :message, :presence => true
	after_create :post_cap
	
	def post_cap
		if Post.count>=255
			Post.order('created_at asc').first.destroy
		end
	end
	#Need to change posts who have this post as its parent to have the parent nil when destroyed
end
