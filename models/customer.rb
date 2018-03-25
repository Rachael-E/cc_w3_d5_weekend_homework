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

###################################
          ## INSTANCE METHODS ##
###################################

# allow a customer to buy a ticket
def buy_ticket()
  film_info = self.films()
  film_price = film_info.map{|film| film.price}
  combined_film_price = film_price.sum
  customer_funds = @funds
  customer_balance = customer_funds -= film_price.sum
  return customer_balance
end

def tickets_bought()
  tickets_bought = self.tickets
  return tickets_bought.length
end
# check how many tickets a customer bought

def tickets() #return Array of ticket objects for given customer
  sql = "SELECT * FROM tickets where customer_id = $1"
  values = [@id]
  tickets_data = SqlRunner.run(sql, values)
  return tickets_data.map{|ticket| Ticket.new(ticket)}
end



###################################
            ## CRUD ##
###################################
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
