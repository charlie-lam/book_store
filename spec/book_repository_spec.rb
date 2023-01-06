require 'book_repository'

def reset_books_table
    seed_sql = File.read('spec/seeds_book_store.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'book_store_test' })
    connection.exec(seed_sql)
end
  
describe BookRepository do
    before(:each) do 
      reset_books_table
    end
  
    # (your tests will go here).
    it "Should return the length of the books table" do
        repo = BookRepository.new

        books = repo.all
        expect(books.length).to eq 5
    end

    it "Should return the id of the first book entry" do
        repo = BookRepository.new

        books = repo.all
        expect(books[0].id).to eq 1
    end

    it "Should return the length of the books table" do
        repo = BookRepository.new

        books = repo.all
        expect(books[0].title).to eq 'Nineteen Eighty-Four'
    end

    it "Should return the length of the books table" do
        repo = BookRepository.new

        books = repo.all
        expect(books[0].author_name).to eq 'George Orwell'
    end
end