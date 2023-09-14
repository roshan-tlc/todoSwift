//
// Created by Krithik Roshan on 07/09/23.
//

import Foundation

class CredentialTable : ObservableObject {

    static let shared = CredentialTable()

    private let db = InitDataBase().getDb()

    private init() {}

    func createTable() throws {

        guard let db = db else { return }

        do {
            //try db.run("Drop table Credential")
            try db.run("CREATE TABLE IF NOT EXISTS Credential (id INTEGER PRIMARY KEY, email TEXT NOT NULL UNIQUE, password TEXT NOT NULL, hint TEXT)")
        } catch {
            throw error
        }
    }

    func insert(credential:Credential) throws {

        guard let db = db else { return }

        let query = "INSERT INTO Credential (id, email, password, hint) VALUES (?,?,?,?)"

        do {
            try db.run(query, credential.getId(), credential.getEmail(), credential.getPassword(), credential.getHint())
            print(credential.getId(), credential.getEmail(), credential.getPassword(), credential.getHint())
        } catch {
            throw error
        }
    }

    func validation(email:String, password:String) throws -> Int64 {

        guard let db = db else { return 0}
        print(email, password)
        let query = " SELECT id from Credential WHERE email = ? and password = ? "

        do {
            for row in try db.prepare(query, email, password) {
                let id = row[0] as! Int64
                if id > 0 {
                    return id
                }
            }
        } catch {
            throw error
        }
        return 0
    }

    func updatePassword(email:String, password:String) throws {

        guard let db = db else { return }

        let query = " UPDATE Credential SET password = ? where email = ?"

        do {
            try db.run(query, password, email)
        } catch {
            throw error
        }
    }

    func getAllEmail() throws -> [String] {

        guard let db = db  else {  return [] }
        var emails:[String] = []

        do {
            for row in try db.run("SELECT email FROM USER") {
                print(row[0] as! String )
                emails.append(row[0] as! String)
            }

        } catch {
            throw error
        }
        return emails
    }

    func update(credential:Credential) throws  {
        guard let db = db else { return }

        let query = " UPDATE Credential SET email = ? , password = ? , hint = ? WHERE id = ?"

        do {
            try db.run(query, credential.getEmail(), credential.getPassword(), credential.getHint(), credential.getId())
        } catch {
            throw error
        }
    }

    func remove(id:Int64) throws {

        guard let db = db else { return }

        let query = "DELETE FROM Credential WHERE id = ?"

        do {
            try db.run(query,id)
        } catch {
            throw error
        }
    }
}
