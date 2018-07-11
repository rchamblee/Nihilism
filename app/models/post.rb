class Post < ActiveRecord::Base
	#Move this later
	#The built in encoder is inadequet as it doesn't do '#' and ';'
	def self.escape(str)
		str.gsub(/[&><"'#;]/,"&" => "&amp;", ">" => "&gt;", "<" => "&lt;", '"' => "&quot;", "'" => "&#39;", "#" => "&#x23;", ";" => "&#x3B;")
	end
	
	@@spec = Riseup::Spec.new([[escape("\n"),"<br/>"],
		[escape("\\="),escape("=")],
		[escape("\\$"),escape("$")],
		[escape("\\`"),escape("`")],
		[escape("\\*"),escape("*")],
		[escape("\\#"),escape("#")],
		[escape("=="),"<span class=\"redtext\">","</span>"],
		[escape("$"),"<span class=\"rainbowtext\">","</span>"],
		[escape("#"),"<span class=\"threedtext\">","</span>"],
		[escape("`"), "<code>","</code>"],
		[escape("**"),"<b>","</b>"],
		[escape("*"),"<i>","</i>"],
		])

	validates :message, :presence => true
	after_create :post_cap
	after_update :update_children

	def html
		"<p>"+Riseup::Parser.new(self.class.escape(self.message),@@spec).parse+"</p>"
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
