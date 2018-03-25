require_relative("../db/sql_runner")
require_relative("customer")
require_relative("ticket")

class Film

  attr_reader :id, :title
  attr_accessor :price

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

###################################
              ## CRUD ##
  ###################################
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

  def customer_count()
    customer_count = self.customers
    return customer_count.length
  end
## Show all customers who have been to see a particular film ##
  def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id WHERE film_id = $1"
    values = [@id]
    customers_data = SqlRunner.run(sql, values)
    return Customer.map_items(customers_data)
  end

###################################
          ## INSTANCE METHODS ##
###################################

######################################
          ## CLASS METHODS ##
######################################
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
