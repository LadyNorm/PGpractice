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

    sql = %q[
      UPDATE classmates SET ($1)
      VALUES ($2)
    ]
  end
end