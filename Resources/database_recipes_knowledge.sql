CREATE TABLE IF NOT EXISTS Category (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);

CREATE TABLE IF NOT EXISTS Recipes (id INTEGER PRIMARY KEY AUTOINCREMENT, 
                                    title TEXT, 
                                    categoryid INTEGER,
                                    ingredients TEXT, 
                                    description TEXT, 
                                    duration DECIMAL,
                                   FOREIGN KEY(categoryid) REFERENCES Category(id));

INSERT INTO Category (name) VALUES ('entrada'), ('sopa'),('carne'),('peixe'),('sobremesa');  

INSERT INTO Recipes (title,categoryid,ingredients,description,duration) VALUES (
  'Título',
  '1',
  '[a],[b],[c]',
  'Instruções e métodos',
  '30'
); 

-- search all
SELECT * FROM Category
SELECT * FROM Recipes 

-- search recipe by category id
SELECT * FROM Recipes WHERE categoryid == idToSearch

-- update / changing name for category
UPDATE Category SET name = 'newname' WHERE id = 5;

--delete
DELETE FROM Recipes WHERE id = 1; 




-- swift https://stackoverflow.com/questions/46846769/swift-sqlite3-syntax-and-bind
/* 
func insert(book: inout Book) throws {
    let query = "INSERT INTO book (bookName, bookAuthor, bookDesc, bookDate, bookImg, createdBy) VALUES (?, ?, ?, ?, ?, ?)"

    let statement = try database.prepare(query, parameters: [
        book.title, book.author, book.bookDescription, book.createDate, book.image, book.createdBy
    ])
    try statement.step()
    book.id = Int(database.lastRowId())
}

func update(book: Book) throws {
    let query = "UPDATE Book SET bookName = ?, bookAuthor = ?, bookDesc = ?, bookDate = ?, bookImg = ?, createdBy = ?, WHERE bookId = ?"

    let statement = try database.prepare(query, parameters: [
        book.title, book.author, book.bookDescription, book.createDate, book.image, book.createdBy, book.id
    ])
    try statement.step()
}

func delete(book: Book) throws {
    let query = "DELETE FROM Book WHERE bookId = ?"
    let statement = try database.prepare(query, parameters: [book.id])
    try statement.step()
}

func select(bookId: Int) throws -> Book? {
    let query = "SELECT bookId, bookName, bookAuthor, bookDesc, bookDate, bookImg, createdBy FROM Book WHERE bookId = ?"
    let statement = try database.prepare(query, parameters: [bookId])
    if try statement.step() == .row {
        return book(for: statement)
    } else {
        return nil
    }
}

func selectAll() throws -> [Book] {
    let query = "SELECT bookId, bookName, bookAuthor, bookDesc, bookDate, bookImg, createdBy FROM Book"
    let statement = try database.prepare(query)

    var books = [Book]()
    while try statement.step() == .row {
        if let book = book(for: statement) {
            books.append(book)
        }
    }
    return books
}

func book(for statement: Statement) -> Book? {
    guard
        let id = Int(from: statement, index: 0),
        let title = String(from: statement, index: 1),
        let author = String(from: statement, index: 2),
        let description = String(from: statement, index: 3),
        let date = Date(from: statement, index: 4),
        let createdBy = String(from: statement, index: 6) else {
            return nil
    }

    let data = Data(from: statement, index: 5)

    return Book(id: id, image: data, title: title, author: author, bookDescription: description, createDate: date, createdBy: createdBy)
} 
*/