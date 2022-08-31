# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'json'

Saif = User.create(name: 'Saif')
Ahmed = User.create(name: 'Ahmed')
Emilia = User.create(name: 'Emilia')
Farnando = User.create(name: 'Farnando')

food1 = Food.create(id: 1, name: 'Food1', measurement_unit: 'g', price: 10.5, quantity: 10)
food2 = Food.create(id: 2, name: 'Food2', measurement_unit: 'kg', price: 20.5, quantity: 20)
food3 = Food.create(id: 3, name: 'Food3', measurement_unit: 'g', price: 30.5, quantity: 30)
food4 = Food.create(id: 4, name: 'Food4', measurement_unit: 'kg', price: 40.5, quantity: 40)