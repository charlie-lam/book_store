# Book Store Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).


## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
  TRUNCATE TABLE books RESTART IDENTITY;
  DROP TABLE IF EXISTS "public"."books";
  -- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

  -- Sequence and defined type
  CREATE SEQUENCE IF NOT EXISTS books_id_seq;

  -- Table Definition
  CREATE TABLE "public"."books" (
      "id" SERIAL,
      "title" text,
      "author_name" text,
      PRIMARY KEY ("id")
  );

  INSERT INTO "public"."books" ("id", "title", "author_name") VALUES
  (1, 'Nineteen Eighty-Four', 'George Orwell'),
  (2, 'Mrs Dalloway', 'Virginia Woolf'),
  (3, 'Emma', 'Jane Austen'),
  (4, 'Dracula', 'Bram Stoker'),
  (5, 'The Age of Innocence', 'Edith Wharton');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 book_store_test < seeds_book_store.sql
```

## 3. Define the class titles

Usually, the Model class title will be the capitalised table title (single instead of plural). The same title is then suffixed by `Repository` for the Repository class title.

```ruby
# EXAMPLE
# Table title: books

# Model class
# (in lib/book.rb)
class Book
end

# Repository class
# (in lib/book_repository.rb)
class BookRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table title: books

# Model class
# (in lib/book.rb)

class Book

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :author_name
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# Book = Book.new
# Book.title = 'Jo'
# Book.title
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table title: books


# Repository class
# (in lib/book_repository.rb)

class BookRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, author_name FROM books;

    # Returns an array of book objects.
  end
=begin
  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, author_name FROM books WHERE id = $1;

    # Returns a single book object.
  end

  # Add more methods below for each operation you'd like to implement.

   def create(book, release_year)
    # Executes the SQL query:
    # INSERT INTO Books (title, release_year) VALUES (Book.title, Book.release_year)

    # Returns nothing

   end

   def update(Book, column, new_data)
    # Executes the SQL query:
    # UPDATE Books SET column = Book.column WHERE title = Book.title
    
    # Returns nothing
   end

   def delete(Book)
  
    # Executes the SQL query:
    # DELETE FROM Books WHERE title = Book.title

    # Returns nothing
   end
=end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all Books


repo = bookRepository.new

books = repo.all

books.length # =>  5

books[0].id # =>  1
books[0].title # =>  'Nineteen Eighty-Four'
books[0].author_name# =>  'George Orwell'

=begin
# 2
# Get a single Book

repo = BookRepository.new

Book = repo.find(1)

Book.id # =>  1
Book.title # =>  'Doolittle'
Book.release_year # =>  '1989'

# Add more examples for each method

#3
# Create an Book

repo = BookRepository.new

queen = Book.create("Queen", 1973)
repo.create(queen)
Book = repo.find(15)

Book.title # => 'Queen'

#4
# Update an Book

repo = BookRepository.new

repo.update("Doolittle", "release_year", 1998)

Book = repo.find(1)
Book.release_year # => 1998

#5
# Delete an Book

repo = BookRepository.new

repo.delete("Doolittle")

=end


```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/Book_repository_spec.rb

def reset_books_table
  seed_sql = File.read('spec/seeds_book_store.sql')
  connection = PG.connect({ host: '127.0.0.1', dbtitle: 'book_store_test' })
  connection.exec(seed_sql)
end

describe BookRepository do
  before(:each) do 
    reset_books_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
