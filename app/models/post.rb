class Post < ActiveRecord::Base
	@@spec = Riseup::Spec.new([[CGI::escapeHTML("\n"),"<br/>"],
		[CGI::escapeHTML("=="),"<span class=\"redtext\">","</span>"],
		[CGI::escapeHTML("$"),"<span class=\"rainbowtext\">","</span>"],
		[CGI::escapeHTML("`"), "<code>","</code>"],
		[CGI::escapeHTML("**"),"<b>","</b>"],
		[CGI::escapeHTML("*"),"<i>","</i>"],
		])

	validates :message, :presence => true
	after_create :post_cap
	after_update :update_children

	def html
		"<p>"+Riseup::Parser.new(CGI::escapeHTML(self.message),@@spec).parse+"</p>"
	end
	
	def self.reply(msg, parent_id="")
		post_id = Post.create(message: msg, parent: parent_id).id
		if parent_id != "" && parent_id != nil
			Post.find(parent_id).update(last_reply: post_id)
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
	
	def update_children
		if @parent
			Post.find(@parent).update(last_reply: @id)
		end
	end
end
