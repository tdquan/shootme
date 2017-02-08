class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
     t.references :user, foreign_key: true
     t.references :client, references: :users

     t.timestamps
    end

    create_table :messages do |t|
     t.text :body
     t.references :conversation, index: true
     t.references :user, index: true
     t.boolean :read, :default => false

     t.timestamps
    end
  end
end
