//
// Created by TrinhHC on 10/9/18.
// Copyright (c) 2018 TrinhHC. All rights reserved.
//

import Foundation
import RealmSwift
class DBManager {
    static let shared:DBManager = DBManager()
    
    //For check data
    func isExistedUtility()->Bool{
        let realm = try! Realm()
        return realm.objects(UtilityModel.self).isEmpty
    }
    func isExistedDistrict()->Bool{
        let realm = try! Realm()
        return realm.objects(DistrictModel.self).first != nil ? true : false
    }
    func isExistedCity()->Bool{
        let realm = try! Realm()
        return realm.objects(CityModel.self).first != nil ? true : false
    }
    
    func isExisted<T:Object>(ofType:T.Type)->Bool{
        let realm = try! Realm()
        return realm.objects(T.self).count != 0
    }
    //For Common
    func getRecord<T:Object>(id:Int,ofType:T.Type)->T?{
        let realm = try! Realm()
        return realm.object(ofType:T.self, forPrimaryKey: id)
    }
    func getRecords<T:Object>(ofType:T.Type) -> Results<T>?{
        let realm = try! Realm()
        return  realm.objects(T.self)
    }
    
    func addRecords<T:Object>(ofType:T.Type,objects:[T])->Bool{
        let realm = try! Realm()
        do{
            try realm.write {
                realm.add(objects)
            }
            return true
        }catch{
            return false
        }
    }
    
    func deleteAllRecords<T:Object>(ofType:T.Type) {
        let realm = try! Realm()
        do {
            let objects = realm.objects(T.self)
            try realm.write {
                realm.delete(objects)
            }
        } catch  {
            print("Cannot delete all Disctrict")
        }
    }
    func updateRecord<T:Object>(ofType:T.Type,object:T)->Bool{
        let realm = try! Realm()
        do{
            try realm.write {
                realm.add(object, update: true)
            }
            return true
        }catch{
            return false
        }
    }
    
    //For SingletonMOdel
    func getSingletonModel<T:Object>(ofType:T.Type)->T?{
        let realm = try! Realm()
        return realm.objects(T.self).first
        
    }
    func addSingletonModel<T:Object>(ofType:T.Type,object:T)->Bool{
        let realm = try! Realm()
        do{
            try realm.write {
                realm.add(object, update: true)
            }
            return true
        }catch{
            return false
        }
    }
    
    
    //For User
    func getUser() -> UserModel?{
        let realm = try! Realm()
        return  realm.objects(UserModel.self).first
        
    }
    
    func addUser(user:UserModel)->Bool{
        let realm = try! Realm()
        do{
            self.deleteAllRealmDB()//delete all relative data when logout
            guard let _ = getUser() else{
                try realm.write {
                    realm.add(user)
                }
                return true
            }
            return false
        }catch{
            return false
        }
    }
    
    func updateUser(user:UserModel)->Bool{
        let realm = try! Realm()
        do{
            try realm.write {
                realm.add(user, update:true)
            }
            return true
        }catch{
            return false
        }
    }
    
    func deleteUser(user:UserModel)->Bool{
        let realm = try! Realm()
        do{
            try realm.write {
                realm.delete(user)
            }
            return true
        }catch{
            return false
        }
    }
    func deleteAllRealmDB() {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch  {
            print("Cannot delete all user")
        }
    }
}
