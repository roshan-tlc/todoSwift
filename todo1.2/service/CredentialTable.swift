//
// Created by Krithik Roshan on 07/09/23.
//

import Foundation

class CredentialTable : ObservableObject {

    static let shared = CredentialTable()

    private let db = InitDataBase().getDb()

    private init() {}

    func createTable() {

        guard let db = db else { return }

        do {
           // try db.run("Drop table Credential")
            try db.run("CREATE TABLE IF NOT EXISTS Credential (id INTEGER PRIMARY KEY, email TEXT NOT NULL UNIQUE, password TEXT NOT NULL)")
        } catch {
            print("Error while creating credential table \(error)")
        }
    }

    func insert(id:Int64, email:String, password:String) {

        guard let db = db else { return }

        let query = "INSERT INTO Credential (id, email, password) VALUES (?,?,?)"

        do {
            try db.run(query, id, email, password)

        } catch {
            print("error while inserting user in credential \(error)")
        }
    }

    func validation(email:String, password:String) -> Int64 {

        guard let db = db else { return 0}
        print(email, password)
        let query = " SELECT id from Credential WHERE email = ? and password = ? "

        do {
            for row in try db.prepare(query,email, password) {
                let id = row[0] as! Int64
                if id > 0 {
                    return id
                }
            }
        } catch {
            print("Error on validating user in credential \(error)")
        }
        return 0
    }

    func updatePassword(email:String, password:String) {

        guard let db = db else { return }

        let query = " UPDATE Credential SET password = ? where email = ?"

        do {
            print(getAllEmail(),"all")
            try db.run(query, password, email)
        } catch {
            print("error occurred while updating the password in credential \(error)")
        }
    }

    func getAllEmail() -> [String] {

        guard let db = db  else {  return [] }
        var emails:[String] = []

        do {
            for row in try db.run("SELECT email FROM USER") {
                print(row[0] as! String )
                emails.append(row[0] as! String)
            }

        } catch {
            print("Error on retrieving emails form the credential table")
        }
        return emails
    }

    func update(id:Int64, email:String, password:String) {
        guard let db = db else { return }

        let query = " UPDATE Credential SET email = ? , password = ?  WHERE id = ?"

        do {
            try db.run(query, email, password, id)
        } catch {
            print("error while update user in credential: \(error)")
        }
    }

    func remove(id:Int64) {

        guard let db = db else { return }

        let query = "DELETE FROM Credential WHERE id = ?"

        do {
            try db.run(query,id)
        } catch {
            print("error on remove user from credential table : \(error)")
        }
    }
}
