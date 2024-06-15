//
//  ContentView.swift
//  SwiftUIFirestore
//
//  Created by Chirag Gujarati on 5/4/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var users: [User] = []
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                HStack(spacing: 10) {
                    Text("Add User")
                        .padding()
                    
                    Button("Save") {
                        if viewModel.isValidate() {
                            let newUser = User(id: UUID().uuidString, name: viewModel.name, gender: viewModel.gender, profilePic: viewModel.profilePic, phoneNumber: viewModel.phoneNumber, email: viewModel.email)
                            viewModel.addUser(user: newUser) { error in
                                if error == nil{
                                    getUsers()
                                }
                            }
                        }
                    }
                    .padding()
                    .buttonStyle(.bordered)
                }
                
                VStack(spacing: 5) {
                    TextField("Name", text: $viewModel.name)
                    
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Picker(selection: $viewModel.gender, label: Text("Gender")) {
                        ForEach(viewModel.genders, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Phone Number", text: $viewModel.phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    TextField("Profile Photo (Optional)", text: $viewModel.profilePic)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding()
                
                Text(users.count > 0 ? "Users List" : "No Users")
                    .padding()
                
                List {
                    ForEach(users) { user in
                        NavigationLink {
                            UserDetailView(user: user) { user in
                                viewModel.updateUser(user: user, completion: { error in
                                    if error == nil{
                                        if let index = self.users.firstIndex(where: { $0.id == user.id }) {
                                            self.users[index] = user
                                        }
                                    }
                                })
                            }
                        } label: {
                            UserRow(user: user)
                                .listRowSeparator(.hidden)
                        }
                    }.onDelete { indexSet in
                        indexSet.forEach { index in
                            viewModel.deleteUser(user: users[index]) { error in
                                if error == nil{
                                    DispatchQueue.main.async {
                                        users.remove(atOffsets: indexSet)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .alert("Please Fill all details", isPresented: $viewModel.showAlert, actions: {
            })
            .navigationTitle("Users")

        }
        .onAppear {
            getUsers()
        }
    }
        
    func getUsers(){
        viewModel.getUsersList { fetchedUsers, error in
            if let fetchedUsers = fetchedUsers {
                self.users = fetchedUsers
            }
        }
    }
    
    @ViewBuilder
    func UserRow(user: User) -> some View {
        HStack {
            WebImage(url: URL(string: user.profilePic)) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person")
            }
            .cornerRadius(25)
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                Text(user.gender)
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .frame(height: 30)
        .padding()
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
