class CreateInterestsUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :interests, :users
  end
end
