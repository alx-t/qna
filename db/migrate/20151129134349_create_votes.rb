class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :value, default: 0
      t.references :votable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
