class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.jsonb :spotify_credentials
      t.timestamps
    end
  end
end
