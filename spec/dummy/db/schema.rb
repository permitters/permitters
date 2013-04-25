ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :employees do |t|
    t.string :a
    t.string :b
    t.string :c
    t.timestamps
  end

  create_table :users do |t|
    t.string :role
  end
end
