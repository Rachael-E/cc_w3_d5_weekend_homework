require_relative("../db/sql_runner")
require_relative("film")
require_relative("ticket")

class Customer
  attr_reader :name, :id
  attr_accessor :funds

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i

  end

  def save()
    sql = "INSERT INTO customers
    (name, funds)
    VALUES
    ($1,$2)
    RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run( sql,values ).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers
    SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run( sql, values )
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  ## show all films for a particular customer ##
  def films()
    sql = "SELECT films.* FROM films INNER JOIN tickets ON films.id = tickets.film_id WHERE customer_id = $1"
    values = [@id]
    films_data = SqlRunner.run(sql, values)
    return Film.map_items(films_data)
  end

######################################
        ## CLASS METHODS ##
######################################
  def self.all()
    sql = "SELECT * FROM customers"
    customer_data = SqlRunner.run(sql)
    return Customer.map_items(customer_data)
  end

  def self.map_items(customer_data)
    result = customer_data.map { |customer| Customer.new( customer ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end



end
