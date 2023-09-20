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
            //try db.run(Properties.dropCredentialTable)
            try db.run(DBProperties.createCredentialTable)
        } catch {
            throw error
        }
    }

    func insert(credential:Credential) throws {

        guard let db = db else { return }

        let query = DBProperties.insertCredential

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
        let query = DBProperties.validateUser

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

        let query = DBProperties.updatePassword

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
            for row in try db.run(DBProperties.getAllEmail) {
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

        let query = DBProperties.updateCredential

        do {
            try db.run(query, credential.getEmail(), credential.getPassword(), credential.getHint(), credential.getId())
        } catch {
            throw error
        }
    }

    func remove(id:Int64) throws {

        guard let db = db else { return }

        let query = DBProperties.removeCredential

        do {
            try db.run(query,id)
        } catch {
            throw error
        }
    }
}
