class Post < ActiveRecord::Base
	validates :message, :presence => true

	def html
		FormatterHelper.format(self.message)
	end

	#Makes a post then removes the oldest unreplied to post, orphaning its children
	def self.reply(msg, parent_id=nil)
		post_to_delete = nil
		if Post.count >= 254
			post_to_delete = Post.order('updated_at asc').first
		end

		post = Post.create(message: msg, parent: parent_id)
		post_id = post.id

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

		logger.error "Attempting fresh trim"
		unless post_to_delete.nil?
			#Doesn't modify updated_at, makes all children top level posts
			posts_to_orphan = Post.where(parent: post_to_delete.id)
			posts_to_orphan.update_all(parent: nil)
			post_to_delete.destroy
		end
		post_id
	end

	def self.get_replies(parent_id="")
		Post.where(parent: parent_id).order("updated_at desc")
	end
end
