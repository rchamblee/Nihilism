class Post < ActiveRecord::Base
	validates :message, :presence => true
	after_create :post_cap

	def html
		FormatterHelper.format(self.message)
	end

	def self.reply(msg, parent_id=nil)
		post_id = Post.create(message: msg, parent: parent_id).id
		if parent_id != "" && !parent_id.nil?
			last_reply = post_id
			until parent_id.nil?
				parent = Post.find(parent_id)
				parent.update(last_reply: last_reply)
				parent.touch
				last_reply = parent
				parent_id = last_reply.parent
			end

		end
		post_id
	end

	def self.get_replies(parent_id="")
		Post.where(parent: parent_id).order("updated_at desc")
	end

	def post_cap
		if Post.count>=255
			Post.order('created_at asc').first.destroy
		end
	end
end
