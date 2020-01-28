require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    DB[:conn].execute(<<~SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    SQL
    )
  end

  def self.drop_table() DB[:conn].execute('DROP TABLE IF EXISTS students') end

  def save
    self.update; return if self.id
    DB[:conn].execute("INSERT INTO students(name, grade) VALUES('#{self.name}','#{self.grade}')")
    @id = DB[:conn].execute('SELECT last_insert_rowid() FROM students')[0][0]
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row) self.new(row[0], row[1], row[2]) end

  def update
    DB[:conn].execute("UPDATE students SET name='#{self.name}', grade='#{self.grade}' WHERE id='#{self.id}'")
  end

end
