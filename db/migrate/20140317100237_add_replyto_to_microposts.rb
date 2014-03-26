class AddReplytoToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :in_reply_to, :integer, after: :user_id
  end
end
