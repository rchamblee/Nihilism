class LastReply < ActiveRecord::Migration
  def change
    add_column :posts, :last_reply, :int
  end
end
