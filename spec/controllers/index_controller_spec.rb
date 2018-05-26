require 'rails_helper'

script = ["A lot of loyalty for a hired gun!!",
	"Perhaps he's wondering why someone would shoot a man before throwing him out of a plane.",
	"At least you can talk. Who are you?",
	"It doesn't matter who we are, what matters is our plan. No one cared who I was until I put on the mask.",
	"If I pull that off would you die.",
	"It would be extreamly painful....",
	"You're a big guy!",
	"For you!"]
				

RSpec.describe IndexController, type: :controller do
	render_views
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
		
		it "shows post timestamps" do
			Post.create(message: script[0])
			get :index
			expect(response.body).to include(DateTime.now.strftime("%d/%m/%Y %H:%M"))
		end
	end
end

feature 'Forms' do
	scenario "posting to board" do
		visit "/"
		fill_in "msg", with: script[0]
		click_button "post"
		visit "/"
		expect(page).to have_content(script[0])
	end
	
	scenario "posting reply" do
		visit "/"
		fill_in "msg", with: script[0]
		click_button "post"
		fill_in "msg", with: script[1]
		click_button "post"
		expect(page).to have_xpath("//div//div")
		expect(page).to have_content(script[1])
	end
	
	scenario "posts have reply links" do
		post_id = Post.create(message: script[0]).id.to_s
		visit "/"
		click_link("reply-"+post_id)
		expect(current_url).to be "/"+post_id
	end
end
