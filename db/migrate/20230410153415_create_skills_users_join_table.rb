class CreateSkillsUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :skills, :users
  end
end
