require 'sqlite3'
require 'pry'

class Dog
  attr_accessor :name, :color, :id

  @@db = SQLite3::Database.new 'dogs.db'

  def self.find(id)
    find = "SELECT * FROM dogs WHERE id = ?"
    result = @@db.execute(find, id)
    Dog.new_from_db(result.first)
  end

  def self.new_from_db(row)
    d = Dog.new
    d.id = row[0]
    d.name = row[1]
    d.color = row[2]
    d.saved!
    d
  end

  def saved!
    @saved = true
  end

  def saved?
    @saved
  end

  def insert
    sql = "INSERT INTO dogs (name, color) VALUES (?,?)"
    @@db.execute(sql, self.name, self.color)
    saved!
    find = "SELECT id FROM dogs WHERE name = ? ORDER BY id DESC LIMIT 1"
    results = @@db.execute(find, self.name)
    @id = results.flatten.first
  end

  def save
    saved? ? update : insert
  end

  def update
    if saved?
      sql = "UPDATE dogs SET name = ?, color = ? WHERE id = ?"
      @@db.execute(sql, self.name, self.color, self.id)
    end
  end

  def ==(other_dog)
    self.id == other_dog.id
  end
end