//
//  HomeViewModel.swift
//  SwiftUIFirestore
//
//  Created by Chirag Gujarati on 5/4/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct User: Identifiable {
    let id: String
    var name: String
    var gender: String
    var profilePic: String
    var phoneNumber: String
    var email: String
}

class HomeViewModel: ObservableObject{
    @Published var name: String = ""
    @Published var gender: String = "Male"
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var profilePic: String = ""
    @Published var showAlert = false
    private var dbRef = Firestore.firestore().collection("users")
    let genders = ["Male", "Female", "Other"]
    
    func getUsersList(completion: @escaping ([User]?, Error?) -> Void){
        dbRef.getDocuments { snap, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let users = snap?.documents.map({ doc in
                return User(id: doc.documentID, name: doc["name"] as? String ?? "", gender: doc["gender"] as? String ?? "", profilePic: doc["profilePic"] as? String ?? "", phoneNumber: doc["phoneNumber"] as? String ?? "", email: doc["email"] as? String ?? "")
            })
            
            completion(users, nil)
        }
    }
    
    func addUser(user: User, completion: @escaping (Error?) -> Void){
        dbRef.addDocument(data: [
            "name": user.name,
            "gender": user.gender,
            "email": user.email,
            "phoneNumber": user.phoneNumber,
            "profilePic": "https://st.depositphotos.com/1537427/3571/v/950/depositphotos_35717211-stock-illustration-vector-user-icon.jpg"
            
        ]) { error in
            if let error = error {
                completion(error)
            } else {
                self.name = ""
                self.gender = ""
                self.email = ""
                self.profilePic = ""
                self.phoneNumber = ""
                completion(nil)
            }
        }
    }
    
    func deleteUser(user: User, completion: @escaping (Error?) -> Void) {
        dbRef.document(user.id).delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func updateUser(user: User, completion: @escaping (Error?) -> Void) {
        dbRef.document(user.id).setData([
            "name": user.name,
            "gender": user.gender,
            "email": user.email,
            "phoneNumber": user.phoneNumber,
            "profilePic": "https://st.depositphotos.com/1537427/3571/v/950/depositphotos_35717211-stock-illustration-vector-user-icon.jpg"
        ]){ error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func isValidate() -> Bool {
        if !name.isEmpty && !gender.isEmpty && !email.isEmpty && !phoneNumber.isEmpty{
            return true
        }else{
            showAlert.toggle()
            return false
        }
    }
    
}
