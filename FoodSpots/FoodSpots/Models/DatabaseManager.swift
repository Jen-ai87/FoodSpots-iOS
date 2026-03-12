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
