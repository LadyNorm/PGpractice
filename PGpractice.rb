require 'pg'


def connect
  conn = PG::Connection.new(host: 'localhost', dbname: 'classmates_db')
end

def query(table)
  result = connect.exec('SELECT * FROM ' + table)
  result.entries
end

def add_classmate
  puts "how many classmates would you like to add?"
  entry = gets.chomp
  puts "what table would you like to add to?"
  table = gets.chomp.to_s
  i = 1
  until i > entry.to_i do
    puts "what is your first name?"
    first = gets.chomp.to_s
    puts "what is your last name?"
    last = gets.chomp.to_s
    puts "what is your twitter handle?"
    twit = gets.chomp.to_s
    connect.exec"INSERT INTO #{table} (first_name, last_name, twitter) VALUES ('#{first}', '#{last}', '#{twit}')"
    i += 1
  end
end

def insert_row(db, record={})
  columns = record.keys
  values = record.values

  columns = columns.join(",")
  values = values.join(",")

  sql = %Q[
      INSERT INTO classmates($1)
      VALUES ($2)
  ]

  db.exec(sql, [columns, values])
end

def delete
  puts "what table would you like to delete from?"
  table = gets.chomp.to_s
  puts "what is the first name of the person you would like to delete?"
  firs = gets.chomp.to_s
  connect.exec"DELETE FROM #{table} WHERE first_name = '#{firs}'"
end