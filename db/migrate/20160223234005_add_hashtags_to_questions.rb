class AddHashtagsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :hashtags, :text, array: true, default: []
    add_index :questions, :hashtags, using: 'gin'
  end
end
