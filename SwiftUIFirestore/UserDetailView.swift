//
//  UserDetailView.swift
//  SwiftUIFirestore
//
//  Created by Chirag Gujarati on 5/4/24.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedGender: String = ""
    @State var user: User
    var onSave: ((User) -> Void)? = nil
    @Environment(\.dismiss) var dismiss
    @State private var selectedUnit: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Name", text: $user.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Picker(selection: $selectedUnit, label: Text("Gender")) {
                ForEach(0..<viewModel.genders.count, id: \.self) { index in
                    Text(viewModel.genders[index])
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onAppear(perform: {
                if let index = viewModel.genders.firstIndex(where: { $0 == user.gender }) {
                    selectedUnit = index
                }
            })
            .onChange(of: selectedUnit, perform: { newValue in
                user.gender = viewModel.genders[newValue]
            })
            
            TextField("Email", text: $user.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Phone Number", text: $user.phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Profile Pic URL", text: $user.profilePic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Save") {
                dismiss()
                onSave?(user)
            }
        }
        .padding()
        Spacer()
    }
}

/*
struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: User())
    }
}
*/
