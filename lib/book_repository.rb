require_relative 'book'

class BookRepository
    def all
        sql = 'SELECT id, title, author_name FROM books'
        resultSet = DatabaseConnection.exec_params(sql, [])

        books = []

        resultSet.each do |entry|
            book = Book.new
            book.id = entry['id'].to_i
            book.title =  entry['title']
            book.author_name = entry['author_name']
            books << book
        end
        return books
    end
end