require 'rails_helper'

RSpec.describe IndexController, type: :controller do
	render_views
	describe "index" do
		it "has a title" do
			get :index
			response.should contain("1b")
		end
	end
end
