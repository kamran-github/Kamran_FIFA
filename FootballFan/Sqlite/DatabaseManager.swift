//
//  DatabaseManager.swift
//  XMLParsingDemo
//
//  Created by Mac mini on 16/09/16.
//  Copyright © 2016 SIPL. All rights reserved.
//

import Foundation

class DatabaseManager: NSObject {
    
    static let sharedInstance = DatabaseManager()
    
    var db: OpaquePointer? = nil
    var counter = 0
    
    func openDatabase() -> OpaquePointer? {
        
        if db == nil {
           // let bundlePath = Bundle.main.bundlePath
            //let part1DbPath = bundlePath + "/Database1.sql"
            let fileManager = FileManager.default
             let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let databasePath = documentsURL?.appendingPathComponent("db3.sqlite3").path
           // print("directory path:", documentsURL?.path as Any)
           // print("database path:", databasePath as Any)
            if !fileManager.fileExists(atPath: databasePath!) {
                    //fileManager.createFile(atPath: databasePath, contents: nil, attributes: nil)
                }
            
            if sqlite3_open(databasePath, &db) == SQLITE_OK {
                //print("Successfully opened connection to database at \(String(describing: databasePath))")
                
                //let tableDetail:NSArray = query(["name"], FROM: "db3", WHERE: "type='table'AND name= 'messages'")
                
                //if tableDetail.count != 3 {
                if(createTable("messages", Fields: "ID INTEGER PRIMARY KEY AUTOINCREMENT,userName text,userAvatar text,badgeCounts integer,lastMessage text,lastTime text,lastDate integer,chatType text,banterNickName text,isJoined text,isAdmin text,banterStatus text,supportedTeam integer,opponentTeam integer,banterUsers text,roomJID text,mySupportedTeam integer"))
                {
                    print("Unable to create messages table. Ravi")
                }
                if(createTable("messages_details", Fields: "ID INTEGER PRIMARY KEY AUTOINCREMENT,toUserJID text,fromUserJID text,messageId text,messageContent text,messageType text,supportteam integer,userName text,status text,time integer,isIncoming text,filePath text,thumb text,fileLocalId text,isFile text,fileType text,fileName text,caption text,deleverUsers text,receivedUsers text,deleverUsersCount integer,chatType text,banterNickName text"))
                {
                    print("Unable to create messages_details table. Ravi")
                }
                if(createTable("bantersound", Fields: "ID INTEGER PRIMARY KEY AUTOINCREMENT,toUserJID text,toUsername text,soundValue integer"))
                {
                    print("Unable to create bantersound table. Ravi")
                }
                //}
                
            } else {
                _ = String(cString: sqlite3_errmsg(db))
               // print("Unable to open database. Verify that you created the directory described " +
                   // "in the Getting Started section. Error: \(errorMessage)")
            }
        }
        return db!
    }
    
    func createTable(_ TableName: String, Fields: String) -> Bool {
        var success: Bool = false
        
        if db != nil {
            
            let createTableString = "CREATE TABLE \(TableName)(\(Fields));"
            // 1
            var createTableStatement: OpaquePointer? = nil
            // 2
            if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
                // 3
                if sqlite3_step(createTableStatement) == SQLITE_DONE {
                   // print("\(TableName) table created.")
                    success = true
                } else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    //print("\(TableName) table could not be created. Error: \(errorMessage)")
                    success = false
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                //print("CREATE TABLE statement could not be prepared. Error: \(errorMessage)")
                success = false
            }
            // 4
            sqlite3_finalize(createTableStatement)
        }else{
            
        }
        
        
        return success
    }
    
    func insert(_ TableName: String, ColumnsAndValues: NSDictionary) {
        
        if openDatabase() != nil {
            counter = 0
            let columns = ColumnsAndValues.allKeys
            
            var columnsStr = ""
            var valuesStr = ""
            
            for (index, columnKey) in columns.enumerated() {
                
                if index == (columns.count-1) {
                    columnsStr = columnsStr + (columnKey as! String)
                    valuesStr = valuesStr + "'\(ColumnsAndValues.object(forKey: columnKey)!)'"
                }else{
                    columnsStr = columnsStr + "\(columnKey),"
                    valuesStr = valuesStr + "'\(ColumnsAndValues.object(forKey: columnKey)!)',"
                }
            }
            
            let insertStatementString1 = "INSERT INTO \(TableName) (\(columnsStr)) VALUES (\(valuesStr));"
            var insertStatement: OpaquePointer? = nil
             print("sqlQurey:\(insertStatementString1)")
            // 1
            if sqlite3_prepare_v2(db, insertStatementString1, -1, &insertStatement, nil) == SQLITE_OK {
                
                // 4
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                    
                } else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                   // print("Could not insert row. Error: \(errorMessage)")
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                //print("INSERT statement could not be prepared. Error: \(errorMessage)")
            }
            // 5
            sqlite3_finalize(insertStatement)
        }else{
            openDatabase()
            counter = counter + 1
            if counter >= 5 {
                print("Error in connecting to Database.")
                return
            }/*else{
                insert(TableName, ColumnsAndValues: ColumnsAndValues)
            }*/
        }
    }
    
    func query(_ SELECT: [NSString], FROM: String, WHERE: String) -> NSMutableArray {
        
        let resultArry: NSMutableArray = NSMutableArray()
        
        if openDatabase() != nil {
            counter = 0
            
            var selectStr: String = ""
            for (index, name) in SELECT.enumerated() {
                if index == (SELECT.count-1) {
                    selectStr = selectStr + (name as String)
                }else{
                    selectStr = selectStr + "\(name),"
                }
            }
            
            var queryStatementString = "SELECT \(selectStr) FROM \(FROM);"
            
            if WHERE != "" {
                queryStatementString = queryStatementString + " WHERE \(WHERE)"
            }
            
            var queryStatement: OpaquePointer? = nil
            // 1
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                // 2
                
                while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                    let resutDict = NSMutableDictionary()
                    
                    for i in 0 ..< sqlite3_data_count(queryStatement) {
                        
                        let queryResultCol = sqlite3_column_text(queryStatement, i)
                        let value = String(cString: queryResultCol!)
//                      let value = String(cString: UnsafePointer<CChar>(queryResultCol!))
                        let name = sqlite3_column_name(queryStatement, i)
                        let key = String(cString: UnsafePointer<CChar>(name!))
                        
                        resutDict.setObject(value, forKey: key as NSCopying)
                    }
                    
                    resultArry.add(resutDict)
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("SELECT statement could not be prepared. Error: \(errorMessage)")
            }
            
            // 6
            sqlite3_finalize(queryStatement)
            
        }else{
            openDatabase()
            counter = counter + 1
            if counter >= 5 {
                print("Error in connecting to Database.")
                resultArry.add("Error in connecting to Database.")
                return resultArry
            }
        }
        
        return resultArry
    }
    
    
    func update() {
        let updateStatementString = "UPDATE Contact SET Name = 'Chris' WHERE Id = 1;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func delete() {
        let deleteStatementStirng = "DELETE FROM Contact WHERE Id = 1;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    func deleteMessages() {
        let deleteStatementStirng = "DELETE FROM messages ;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    func deleteMessages_Details() {
        let deleteStatementStirng = "DELETE FROM messages_details ;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    func closeDB() {
        sqlite3_close(db)
    }
    func SelectedBanterSound( FROM: String, WHERE: String) -> Int {
        
        var resultArry: Int = 1
        
        if openDatabase() != nil {
            counter = 0
            
            var selectStr: String = "soundValue"
            /*for (index, name) in SELECT.enumerated() {
             if index == (SELECT.count-1) {
             selectStr = selectStr + (name as String)
             }else{
             selectStr = selectStr + "\(name),"
             }
             }soundValue
             */
            var queryStatementString = "SELECT \(selectStr) FROM \(FROM)"
            
            if WHERE != "" {
                queryStatementString = queryStatementString + " WHERE toUserJID = '\(WHERE)';"
            }
            
            var queryStatement: OpaquePointer? = nil
            // 1
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                // 2
                
                while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                   // let resutDict = NSMutableDictionary()
                    
                    for i in 0 ..< sqlite3_data_count(queryStatement) {
                        
                        let queryResultCol = sqlite3_column_text(queryStatement, i)
                        let value = sqlite3_column_int(queryStatement, i)
                        //                      let value = String(cString: UnsafePointer<CChar>(queryResultCol!))
                        let name = sqlite3_column_name(queryStatement, i)
                        let key = String(cString: UnsafePointer<CChar>(name!))
                        resultArry = Int(value)
                       // resutDict.setObject(value, forKey: key as NSCopying)
                    }
                    
                    //resultArry.add(resutDict)
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("SELECT statement could not be prepared. Error: \(errorMessage)")
            }
            
            // 6
            sqlite3_finalize(queryStatement)
            
        }else{
            openDatabase()
            counter = counter + 1
            if counter >= 5 {
                print("Error in connecting to Database.")
               // resultArry.add("Error in connecting to Database.")
                return resultArry
            }
        }
        
        return resultArry
    }
    func BanterAvablity( FROM: String, WHERE: String) -> NSMutableArray {
        
        let resultArry: NSMutableArray = NSMutableArray()
        
        if openDatabase() != nil {
            counter = 0
            
            var selectStr: String = "roomJID"
            /*for (index, name) in SELECT.enumerated() {
             if index == (SELECT.count-1) {
             selectStr = selectStr + (name as String)
             }else{
             selectStr = selectStr + "\(name),"
             }
             }
             */
            var queryStatementString = "SELECT \(selectStr) FROM \(FROM)"
            
            if WHERE != "" {
                queryStatementString = queryStatementString + " WHERE roomJID = '\(WHERE)';"
            }
            
            var queryStatement: OpaquePointer? = nil
            // 1
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                // 2
                
                while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                    let resutDict = NSMutableDictionary()
                    
                    for i in 0 ..< sqlite3_data_count(queryStatement) {
                        
                        let queryResultCol = sqlite3_column_text(queryStatement, i)
                        let value = String(cString: queryResultCol!)
                        //                      let value = String(cString: UnsafePointer<CChar>(queryResultCol!))
                        let name = sqlite3_column_name(queryStatement, i)
                        let key = String(cString: UnsafePointer<CChar>(name!))
                        
                        resutDict.setObject(value, forKey: key as NSCopying)
                    }
                    
                    resultArry.add(resutDict)
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("SELECT statement could not be prepared. Error: \(errorMessage)")
            }
            
            // 6
            sqlite3_finalize(queryStatement)
            
        }else{
            openDatabase()
            counter = counter + 1
            if counter >= 5 {
                print("Error in connecting to Database.")
                resultArry.add("Error in connecting to Database.")
                return resultArry
            }
        }
        closeDB()
        return resultArry
    }
    func FetchAllLocalchatdetailData(WHERE: String) -> NSMutableArray {
        
        let resultArry: NSMutableArray = NSMutableArray()
        
        if openDatabase() != nil {
            counter = 0
            
            var selectStr: String = "roomJID"
            /*for (index, name) in SELECT.enumerated() {
             if index == (SELECT.count-1) {
             selectStr = selectStr + (name as String)
             }else{
             selectStr = selectStr + "\(name),"
             }
             }
             */
            var queryStatementString = "SELECT * FROM messages_details"
           // var queryStatementString = "SELECT \(selectStr) FROM \(FROM)"
            
            if WHERE != "" {
                queryStatementString = queryStatementString + " WHERE toUserJID = '\(WHERE)';"
            }
            
            var queryStatement: OpaquePointer? = nil
            // 1
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                // 2
                
                while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                    let resutDict = NSMutableDictionary()
                    
                    for i in 0 ..< sqlite3_data_count(queryStatement) {
                        
                        let queryResultCol = sqlite3_column_text(queryStatement, i)
                        var value: Any = ""
                        
                        
                        //                      let value = String(cString: UnsafePointer<CChar>(queryResultCol!))
                        let name = sqlite3_column_name(queryStatement, i)
                        let key = String(cString: UnsafePointer<CChar>(name!))
                        if(queryResultCol != nil){
                            if(key == "time" || key == "badgeCounts" || key == "supportteam" || key == "deleverUsersCount" || key == "mySupportedTeam"){
                                value = sqlite3_column_int(queryStatement, i)
                            }
                            else{
                                value = String(cString: queryResultCol!)
                            }
                        }
                        resutDict.setObject(value, forKey: key as NSCopying)
                    }
                    
                    resultArry.add(resutDict)
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("SELECT statement could not be prepared. Error: \(errorMessage)")
            }
            
            // 6
            sqlite3_finalize(queryStatement)
            
        }else{
            openDatabase()
            counter = counter + 1
            if counter >= 5 {
                print("Error in connecting to Database.")
                resultArry.add("Error in connecting to Database.")
                return resultArry
            }
        }
        
        return resultArry
    }
    func FetchAllLocalData() -> [String: AnyObject] {
        
        var resultArry = [String: AnyObject]()
        
        if openDatabase() != nil {
            counter = 0
            
           // var selectStr: String = "roomJID"
            /*for (index, name) in SELECT.enumerated() {
             if index == (SELECT.count-1) {
             selectStr = selectStr + (name as String)
             }else{
             selectStr = selectStr + "\(name),"
             }
             }
             */
            let queryStatementString = "SELECT * FROM messages"
            
           
            var queryStatement: OpaquePointer? = nil
            // 1
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                // 2
                
                while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                    var resutDict  = [String: AnyObject]()
                    
                    for i in 0 ..< sqlite3_data_count(queryStatement) {
                        
                        let queryResultCol = sqlite3_column_text(queryStatement, i)
                        var value: Any = ""
                        
                        
                        //                      let value = String(cString: UnsafePointer<CChar>(queryResultCol!))
                        let name = sqlite3_column_name(queryStatement, i)
                        let key = String(cString: UnsafePointer<CChar>(name!))
                        if(queryResultCol != nil){
                            if(key == "lastDate" || key == "badgeCounts" || key == "supportedTeam" || key == "opponentTeam" || key == "mySupportedTeam"){
                                value = sqlite3_column_int(queryStatement, i)
                            }
                            else{
                            value = String(cString: queryResultCol!)
                            }
                        }
                        resutDict[key] = value as AnyObject
                        //resutDict.setObject(value, forKey: key as NSCopying)
                    }
                    let toser = resutDict["roomJID"] as! String
                    let chats = FetchAllLocalchatdetailData(WHERE: resutDict["roomJID"] as! String)
                   // resutDict.setObject(chats, forKey: "Chats" as NSCopying)
                    resutDict["Chats"] = chats as AnyObject
                    //resultArry.add(resutDict)
                    resultArry[toser] = resutDict as AnyObject
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("SELECT statement could not be prepared. Error: \(errorMessage)")
            }
            
            // 6
            sqlite3_finalize(queryStatement)
            
        }else{
            openDatabase()
            counter = counter + 1
            if counter >= 5 {
                print("Error in connecting to Database.")
               // resultArry.append("Error in connecting to Database." as AnyObject)
                return resultArry
            }
        }
        
        return resultArry
    }
    func BanterUpdate(_ TableName: String, ColumnsAndValues: NSDictionary, WHERE: String) {
        
        if openDatabase() != nil {
            counter = 0
            let columns = ColumnsAndValues.allKeys
            
            var columnsStr = ""
            //var valuesStr = ""
            
            for (index, columnKey) in columns.enumerated() {
                
                if index == (columns.count-1) {
                    columnsStr = columnsStr + "\(columnKey as! String) = '\(ColumnsAndValues.object(forKey: columnKey)!)'"
                   // valuesStr = valuesStr + "'\(ColumnsAndValues.object(forKey: columnKey)!)'"
                }
                else if(columnKey as! String == "opponentTeam" || columnKey as! String == "supportedTeam" || columnKey as! String == "mySupportedTeam" || columnKey as! String == "badgeCounts" || columnKey as! String == "lastDate"){
                     columnsStr = columnsStr + "\(columnKey as! String) = \(ColumnsAndValues.object(forKey: columnKey)!), "
                    
                }
                else{
                    columnsStr = columnsStr + "\(columnKey as! String) = '\(ColumnsAndValues.object(forKey: columnKey)!)', "
                    //valuesStr = valuesStr + "'\(ColumnsAndValues.object(forKey: columnKey)!)',"
                }
            }
            //let updateStatementString = "UPDATE Contact SET Name = 'Chris' WHERE Id = 1;"
            let insertStatementString = "UPDATE \(TableName) SET \(columnsStr) WHERE roomJID = '\(WHERE)';"
            var insertStatement: OpaquePointer? = nil
            print("sqlQurey:\(insertStatementString)")
            // 1
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                // 4
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully UPDATE row.")
                } else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("Could not UPDATE row. Error: \(errorMessage)")
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("UPDATE statement could not be prepared. Error: \(errorMessage)")
            }
            // 5
            sqlite3_finalize(insertStatement)
            
        }else{
            openDatabase()
            counter = counter + 1
            if counter >= 5 {
                print("Error in connecting to Database.")
                return
            }/*else{
             insert(TableName, ColumnsAndValues: ColumnsAndValues)
             }*/
        }
        closeDB()
    }
    func BanterSoundUpdate(_ TableName: String, ColumnsAndValues: NSDictionary, WHERE: String) {
        
        if openDatabase() != nil {
            counter = 0
            let columns = ColumnsAndValues.allKeys
            
            var columnsStr = ""
            //var valuesStr = ""
            
            for (index, columnKey) in columns.enumerated() {
                
                if index == (columns.count-1) {
                    columnsStr = columnsStr + "\(columnKey as! String) = '\(ColumnsAndValues.object(forKey: columnKey)!)'"
                    // valuesStr = valuesStr + "'\(ColumnsAndValues.object(forKey: columnKey)!)'"
                }
                else if(columnKey as! String == "soundValue" ){
                    columnsStr = columnsStr + "\(columnKey as! String) = \(ColumnsAndValues.object(forKey: columnKey)!), "
                    
                }
                else{
                    columnsStr = columnsStr + "\(columnKey as! String) = '\(ColumnsAndValues.object(forKey: columnKey)!)', "
                    //valuesStr = valuesStr + "'\(ColumnsAndValues.object(forKey: columnKey)!)',"
                }
            }
            //let updateStatementString = "UPDATE Contact SET Name = 'Chris' WHERE Id = 1;"
            let insertStatementString = "UPDATE \(TableName) SET \(columnsStr) WHERE toUserJID = '\(WHERE)';"
            var insertStatement: OpaquePointer? = nil
            print("sqlQurey:\(insertStatementString)")
            // 1
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                // 4
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully UPDATE row.")
                    if(TableName == "bantersound"){
                        SelectedAllBanterSound()
                    }
                } else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("Could not UPDATE row. Error: \(errorMessage)")
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("UPDATE statement could not be prepared. Error: \(errorMessage)")
            }
            // 5
            sqlite3_finalize(insertStatement)
        }else{
            openDatabase()
            counter = counter + 1
            if counter >= 5 {
                print("Error in connecting to Database.")
                return
            }/*else{
             insert(TableName, ColumnsAndValues: ColumnsAndValues)
             }*/
        }
         closeDB()
    }
    func GetSetLocalChats(_ TableName: String, ColumnsAndValues: NSDictionary, WHERE: String) {
        
        if openDatabase() != nil {
            counter = 0
            let columns = ColumnsAndValues.allKeys
            
            var columnsStr = ""
            //var valuesStr = ""
            
            for (index, columnKey) in columns.enumerated() {
                
                if index == (columns.count-1) {
                    columnsStr = columnsStr + "\(columnKey as! String) = '\(ColumnsAndValues.object(forKey: columnKey)!)'"
                    // valuesStr = valuesStr + "'\(ColumnsAndValues.object(forKey: columnKey)!)'"
                }
                else if(columnKey as! String == "deleverUsersCount" || columnKey as! String == "supportteam" || columnKey as! String == "time" || columnKey as! String == "badgeCounts" || columnKey as! String == "lastDate"){
                    columnsStr = columnsStr + "\(columnKey as! String) = \(ColumnsAndValues.object(forKey: columnKey)!), "
                    
                }
                else{
                    columnsStr = columnsStr + "\(columnKey as! String) = '\(ColumnsAndValues.object(forKey: columnKey)!)', "
                    //valuesStr = valuesStr + "'\(ColumnsAndValues.object(forKey: columnKey)!)',"
                }
            }
            //let updateStatementString = "UPDATE Contact SET Name = 'Chris' WHERE Id = 1;"
            let insertStatementString = "UPDATE \(TableName) SET \(columnsStr) WHERE messageId = '\(WHERE)';"
            var insertStatement: OpaquePointer? = nil
            print("sqlQurey:\(insertStatementString)")
            // 1
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                // 4
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully UPDATE row.")
                } else {
                    let errorMessage = String(cString: sqlite3_errmsg(db))
                    print("Could not UPDATE row. Error: \(errorMessage)")
                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("UPDATE statement could not be prepared. Error: \(errorMessage)")
            }
            // 5
            sqlite3_finalize(insertStatement)
        }else{
            openDatabase()
            counter = counter + 1
            if counter >= 5 {
                print("Error in connecting to Database.")
                return
            }/*else{
             insert(TableName, ColumnsAndValues: ColumnsAndValues)
             }*/
        }
        
    }
    func SelectedAllBanterSound()  {
        
        let resultArry = NSMutableArray()
        
        if openDatabase() != nil {
            counter = 0
            
            
            let queryStatementString = "SELECT * FROM bantersound ;"
            
           
            var queryStatement: OpaquePointer? = nil
            // 1
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                // 2
                
                while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                    var resutDict = [String : AnyObject]()//NSMutableDictionary()
                    
                    for i in 0 ..< sqlite3_data_count(queryStatement) {
                        
                        let queryResultCol = sqlite3_column_text(queryStatement, i)
                        
                        //                      let value = String(cString: UnsafePointer<CChar>(queryResultCol!))
                        let name = sqlite3_column_name(queryStatement, i)
                        let key = String(cString: UnsafePointer<CChar>(name!))
                        var value: Any = ""
                        
                        if(queryResultCol != nil){
                            if(key == "soundValue"){
                                value = sqlite3_column_int(queryStatement, i)
                            }
                            else{
                                value = String(cString: queryResultCol!)
                            }
                        }
                        resutDict[key] = value as AnyObject
                        //resutDict.setObject(value, forKey: key as NSCopying)
                    }
                     //let toser = resutDict["toUserJID"] as! String
                     resultArry.add(resutDict)
                    //resultArry[toser] = resutDict as AnyObject
                }
                do {
                    if(resultArry.count > 0)
                    {
                        let dataArrAllChats = try JSONSerialization.data(withJSONObject: resultArry, options: .prettyPrinted)
                        let strArrAllChats = NSString(data: dataArrAllChats, encoding: String.Encoding.utf8.rawValue)! as String
                        let userD: UserDefaults = UserDefaults.init(suiteName: "group.com.tridecimal.ltd.footballfan")!
                        userD.set(strArrAllChats, forKey: "arrBanterSound")
                        userD.synchronize()
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                //
                /*
                var arrAllBantersMute = NSArray()
                var myRoomId: String = "ec4t636522128781383808@conference.beingcrowd.com"
                let userD2: UserDefaults = UserDefaults(suiteName: "group.com.tridecimal.ltd.footballfan")!
                
                let localAllBantersMute: String? = userD2.string(forKey: "arrBanterSound")
                if localAllBantersMute != nil
                {
                    //Code to parse json data
                    if let data = localAllBantersMute?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                        do {
                            arrAllBantersMute = try JSONSerialization.jsonObject(with:data , options: []) as! NSArray
                            
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                }
                
                let result = arrAllBantersMute.filter({ (text) -> Bool in
                    let tmp: NSDictionary = text as! NSDictionary
                    let val = tmp.value(forKey: "toUserJID")
                    let range = (val as AnyObject).range(of: myRoomId, options: NSString.CompareOptions.caseInsensitive)
                    return range.location != NSNotFound
                })
                
                if(result.count > 0)
                {
                    let dict: NSDictionary? = result[0] as? NSDictionary
                    let sound = dict?.value(forKey: "soundValue") as? Int
                    let roomName = dict?.value(forKey: "toUsername") as? String
                    //bestAttemptContent.title = "Test"//String(describing: sound)
                    //bestAttemptContent.body = roomName!
                    
                }*/
                //
                
                
                
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("SELECT statement could not be prepared. Error: \(errorMessage)")
            }
            
            // 6
            sqlite3_finalize(queryStatement)
            
        }else{
            openDatabase()
            counter = counter + 1
            if counter >= 5 {
                print("Error in connecting to Database.")
                // resultArry.add("Error in connecting to Database.")
               
            }
        }
        
       // return resultArry
    }
}
