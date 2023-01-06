require_relative 'lib/database_connection'
require_relative 'lib/book_repository'

# We need to give the database name to the method `connect`.
DatabaseConnection.connect('book_store')

# Perform a SQL query on the database and get the result set.
book_repo = BookRepository.new
books = book_repo.all

# Print out each record from the result set .
books.each do |record|
  p "#{record.id} - #{record.title} - #{record.author_name}"
end