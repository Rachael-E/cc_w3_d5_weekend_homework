require("pry-byebug")
require_relative("models/customer.rb")
require_relative("models/film.rb")
require_relative("models/ticket.rb")
###########################################
Ticket.delete_all()
Film.delete_all()
Customer.delete_all()
###########################################
film1 = Film.new({ 'title' => 'Coco', 'price' => '5' })
film2 = Film.new({ 'title' => 'Black Panther', 'price' => '8'})
film3 = Film.new({ 'title' => 'Thor Ragnarok', 'price' => '10'})
film1.save
film2.save
film3.save
############################################
customer1 = Customer.new({ 'name' => 'Rachael', 'funds' => '50' })
customer2 = Customer.new({ 'name' => 'Kenny', 'funds' => '50' })
customer3 = Customer.new({ 'name' => 'Rebecca', 'funds' => '20' })
customer1.save
customer2.save
customer3.save
###########################################
ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id})
ticket3 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film3.id})
ticket4 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film3.id})
ticket1.save
ticket2.save
ticket3.save
ticket4.save
##########################################

# binding.pry# p film1.customers
p customer3.tickets_bought
# nil
