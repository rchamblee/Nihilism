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
  
  it "deletes old posts after the limit of 255 has been reached" do
    Post.create(message: "Bring back freddo frogs")
    255.times do
      Post.create(message: "E")
    end
    expect(Post.exists?(message: "Bring back freddo frogs")).to be_falsey
  end
end
