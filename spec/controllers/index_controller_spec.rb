require 'rails_helper'

RSpec.describe IndexController, type: :controller do
	render_views
	script = ["A lot of loyalty for a hired gun!!",
		"Perhaps he's wondering why someone would shoot a man before throwing him out of a plane.",
		"At least you can talk. Who are you?",
		"It doesn't matter who we are, what matters is our plan. No one cared who I was until I put on the mask.",
		"If I pull that off would you die.",
		"It would be extreamly painful....",
		"You're a big guy!",
		"For you!"]
				

	describe "index" do
		it "has a title" do
			get :index
			expect(response.body).to match("1b")
		end
		
		it "shows threads" do
			script.each {|i|
				Post.create(message: i)
				get :index
				expect(response.body).to include(CGI.escape_html(i))
			}
		end
		
		it "shows children" do
			last_post = nil
			script.each {|i|
				last_post = Post.create(parent: last_post&.id, message: i)
				get :index
				expect(response.body).to include(CGI.escape_html(i))
			}
		end
	end
end
