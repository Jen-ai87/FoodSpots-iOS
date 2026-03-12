import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    private let SQLITE_TRANSIENT = unsafeBitCast(OpaquePointer(bitPattern: -1), to: sqlite3_destructor_type.self)

    private init() {
        openDatabase()

    }

    deinit {
        sqlite3_close(db)
    }
    
    private func openDatabase() {
        guard let url = try? FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("FoodSpots.sqlite") else { return }

        if sqlite3_open(url.path, &db) != SQLITE_OK {
            print("Error opening database: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    
    private func createTable() {
        let sql = """
            CREATE TABLE IF NOT EXISTS restaurants (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                cuisine_type TEXT NOT NULL,
                description TEXT DEFAULT '',
                address TEXT DEFAULT '',
                latitude REAL NOT NULL DEFAULT 0,
                longitude REAL NOT NULL DEFAULT 0,
                rating REAL NOT NULL DEFAULT 0,
                is_favorite INTEGER DEFAULT 0,
                image_name TEXT DEFAULT ''
            );
        """
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_step(stmt)
        }
        sqlite3_finalize(stmt)
    }
    
    private func seedDataIfNeeded() {
        var stmt: OpaquePointer?
        var count = 0
        if sqlite3_prepare_v2(db, "SELECT COUNT(*) FROM restaurants;", -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_ROW { count = Int(sqlite3_column_int(stmt, 0)) }
        }
        sqlite3_finalize(stmt)
        guard count == 0 else { return }

        let seed: [(String, String, String, String, Double, Double, Double, String)] = [
            ("Bella Italia",    "Italian",  "Authentic Italian cuisine with wood-fired pizzas and homemade pasta.",          "123 King Street West, Toronto, ON",  43.6481, -79.3892, 4.7, ""),
            ("Sakura Sushi",    "Japanese", "Fresh sushi and traditional Japanese dishes in a serene atmosphere.",           "456 Queen Street West, Toronto, ON", 43.6487, -79.3956, 4.9, ""),
            ("El Mariachi",     "Mexican",  "Vibrant Mexican flavors with authentic tacos, enchiladas and more.",            "789 Dundas Street West, Toronto, ON",43.6534, -79.4102, 4.5, ""),
            ("Peking Garden",   "Chinese",  "Classic Chinese dishes and dim sum in a warm, welcoming setting.",              "321 Spadina Ave, Toronto, ON",        43.6512, -79.3987, 4.3, ""),
            ("Spice Route",     "Indian",   "Rich and aromatic Indian curries with traditional tandoor specialties.",        "654 Bloor Street West, Toronto, ON", 43.6645, -79.4132, 4.6, ""),
            ("The Burger Joint","American", "Gourmet burgers with locally sourced ingredients and hand-cut fries.",          "987 College Street, Toronto, ON",     43.6556, -79.4234, 4.4, ""),
            ("Thai Orchid",     "Thai",     "Authentic Thai cuisine with fragrant curries and fresh pad thai.",              "147 Ossington Ave, Toronto, ON",      43.6498, -79.4201, 4.8, ""),
            ("Maison Paris",    "French",   "Elegant French bistro serving classic dishes in a charming environment.",       "258 Church Street, Toronto, ON",      43.6579, -79.3761, 4.6, ""),
            ("Seoul Kitchen",   "Korean",   "Traditional Korean BBQ and comforting dishes from the heart of Seoul.",         "369 Yonge Street, Toronto, ON",       43.6621, -79.3832, 4.7, ""),
            ("Mamma Rosa",      "Italian",  "Family-style Italian restaurant famous for hearty portions and warmth.",        "741 St. Clair Ave West, Toronto, ON", 43.6812, -79.4389, 4.4, ""),
        ]

        let sql = "INSERT INTO restaurants (name, cuisine_type, description, address, latitude, longitude, rating, is_favorite, image_name) VALUES (?, ?, ?, ?, ?, ?, ?, 0, ?);"
        for row in seed {
            var insertStmt: OpaquePointer?
            if sqlite3_prepare_v2(db, sql, -1, &insertStmt, nil) == SQLITE_OK {
                sqlite3_bind_text(insertStmt, 1, row.0, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStmt, 2, row.1, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStmt, 3, row.2, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(insertStmt, 4, row.3, -1, SQLITE_TRANSIENT)
                sqlite3_bind_double(insertStmt, 5, row.4)
                sqlite3_bind_double(insertStmt, 6, row.5)
                sqlite3_bind_double(insertStmt, 7, row.6)
                sqlite3_bind_text(insertStmt, 8, row.7, -1, SQLITE_TRANSIENT)
                sqlite3_step(insertStmt)
            }
            sqlite3_finalize(insertStmt)
        }
    }
    
    func fetchAll() -> [Restaurant] {
        var result: [Restaurant] = []
        let sql = "SELECT id, name, cuisine_type, description, address, latitude, longitude, rating, is_favorite, image_name FROM restaurants ORDER BY id;"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let r = Restaurant(
                    id: sqlite3_column_int64(stmt, 0),
                    name: col(stmt, 1),
                    cuisineType: col(stmt, 2),
                    restaurantDescription: col(stmt, 3),
                    address: col(stmt, 4),
                    latitude: sqlite3_column_double(stmt, 5),
                    longitude: sqlite3_column_double(stmt, 6),
                    rating: sqlite3_column_double(stmt, 7),
                    isFavorite: sqlite3_column_int(stmt, 8) == 1,
                    imageName: col(stmt, 9)
                )
                result.append(r)
            }
        }
        sqlite3_finalize(stmt)
        return result
    }
    
    func toggleFavorite(id: Int64, newValue: Bool) {
        let sql = "UPDATE restaurants SET is_favorite = ? WHERE id = ?;"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, newValue ? 1 : 0)
            sqlite3_bind_int64(stmt, 2, id)
            sqlite3_step(stmt)
        }
        sqlite3_finalize(stmt)
    }

    func insert(_ r: Restaurant) -> Bool {
        let sql = "INSERT INTO restaurants (name, cuisine_type, description, address, latitude, longitude, rating, is_favorite, image_name) VALUES (?, ?, ?, ?, ?, ?, ?, 0, '');"
        var stmt: OpaquePointer?
        var ok = false
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, r.name, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 2, r.cuisineType, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 3, r.restaurantDescription, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 4, r.address, -1, SQLITE_TRANSIENT)
            sqlite3_bind_double(stmt, 5, r.latitude)
            sqlite3_bind_double(stmt, 6, r.longitude)
            sqlite3_bind_double(stmt, 7, r.rating)
            ok = sqlite3_step(stmt) == SQLITE_DONE
        }
        sqlite3_finalize(stmt)
        return ok
    }

    
    private func col(_ stmt: OpaquePointer?, _ idx: Int32) -> String {
        guard let ptr = sqlite3_column_text(stmt, idx) else { return "" }
        return String(cString: ptr)
    }

}
