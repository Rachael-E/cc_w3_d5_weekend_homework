require_relative("../db/sql_runner")
require_relative("customer")

class Film

  attr_reader :id, :title
  attr_accessor :price

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = "INSERT INTO films
    (title, price)
    VALUES
    ($1,$2)
    RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run( sql,values ).first
    @id = film['id'].to_i
  end

  def update()
    sql = "UPDATE films
    SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run( sql, values )
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM films"
    film_data = SqlRunner.run(sql)
    return Film.map_items(film_data)
  end

  def self.map_items(film_data)
    result = film_data.map { |film| Film.new( film ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end



end
