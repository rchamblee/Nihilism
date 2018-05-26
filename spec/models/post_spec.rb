require 'rails_helper'

RSpec.describe Post, type: :model do
  it "Is invalid without text" do
    post = Post.new(message: nil)
    expect(post).to_not be_valid
    
    post = Post.new(message: "")
    expect(post).to_not be_valid
  end
  
  it "Is valid with text" do
    post = Post.new(message: "LOTTA LOYALTY FOR A HIRED GUN")
    expect(post).to be_valid
  end
end
