class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.string :patronymic
      t.string :fullname
      t.string :email
      t.integer :age
      t.string :nationality
      t.string :country
      t.string :gender

      t.timestamps
    end
  end
end
