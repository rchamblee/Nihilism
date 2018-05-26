require 'rails_helper'

RSpec.describe Post, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  it "Is invalid without text" do
    post = Post.new(message: nil)
    expect(post).to_not be_valid
    
    post = Post.new(message: "")
    expect(post).to_not be_valid
  end
end
