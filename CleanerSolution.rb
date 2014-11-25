class Classmate

  def initialize
    @sb = PG.connect(host: 'localhost', dbname: 'classmates_db')
    create_tables
  end

  def create_tables
    sql = %q[
      CREATE TABLE IF NOT EXISTS classmates(
        id PRIMARY SERIAL KEY,
        first_name VARCHAR,
        last_name VARCHAR,
        twitter VARCHAR NOT NULL UNIQUE,
        age INTEGER
      )
    ]

    result = @db.exec(sql)
    result.entries
  end

  def insert_into_table(first, last, twitter, age)
    sql = %q[
      INSERT INTO classmates (first_name, last_name, twitter, age)
      VALUES ($1, $2, $3, $4)
    ]

    result = @db.exec_params(sql, [first, last, twitter, age])
    result.entries
  end

  def view_all_classmates
    sql = 'SELECT * FROM classmates'
    result = @db.exec(sql)
    result.entries
  end

  def delete_a_record(id)
    sql = %q[
      DELETE FROM classmates WHERE id = $1
    ]
    result = @db.exec_params(sql, [id])
    result.entries
  end

  def update_a_record(id, opts={})
    columns = opts.keys
    values = opts.values

    columns = columns.join(',')
    values = values.join(',')

    sql = %q[
      UPDATE classmates SET ($1) = ($2)
    ]

    result = @db.exec_params(sql, [columns, values])
    result.entries
  end

  def find_by_twitter(twitter)
    sql = %q[
      SELECT * FROM classmates WHERE twitter = $1
    ]

    result = @db.exec_params(sql, [twitter])
    result.entries
  end
end

class CLI
  def self.command_list
    puts "Command list:"
    puts " 0. add a record"
    puts " 1. view all records"
    puts " 2. delete a record"
    puts " 3. update a record"
    puts " 4. find by twitter handle"
    puts " 5. exit"
  end

  def self.start
    command_list
    @connection = Classmates.new


    print "==> "
    input = gets.chomp.to_i

    case input
    when 0
      add_record(input)
    when 1
      view_all_classmates
    when 2
      delete_a_record
    when 3
      update_a_record
    when 4
      find_by_twitter
    when 5
      return
    end
  end

# "0 nora neyland lady_norm 25"
  def self.add_record(input)
    pieces = input.split
    first = input[1]
    last = input[2]
    twitter = input[3]
    age = input[4]

    @connection.insert_into_table(first, last, twitter, age)
    start
  end
end