class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :remember_digest
      t.boolean :admin
      t.string :self_introduction
      t.float :target_weight
      t.float :target_body_fat_percentage
      t.string :image

      t.timestamps
    end
  end
end
