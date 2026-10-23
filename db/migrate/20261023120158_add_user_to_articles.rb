class AddUserToArticles < ActiveRecord::Migration[8.1]
  def change
    # Existing articles must be assigned owners before NOT NULL can be enforced.
    add_reference :articles, :user, null: true, foreign_key: true
  end
end
