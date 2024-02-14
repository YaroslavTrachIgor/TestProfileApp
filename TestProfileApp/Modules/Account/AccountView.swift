//
//  AccountView.swift
//  TestProfileApp
//
//  Created by User on 2024-02-09.
//

import Foundation
import SwiftUI

struct AccountView: View {
    
    @State private var isEditing = false
    
    @ObservedObject var profileData: ProfileData
    
    @State private var originalUser: UserProfileModel
    @State private var editedUser: UserProfileModel
    
    @State private var updateState: UpdateState?
    @State private var updateErrorMessage: String = ""
    @State private var updateErrorAlertPresented: Bool = false
    
    init(profileData: ProfileData) {
        self._profileData = ObservedObject(wrappedValue: profileData)
        self._originalUser = State(initialValue: profileData.user)
        self._editedUser = State(initialValue: profileData.user)
    }
    
    var body: some View {
        ZStack {
            List {
                Section {
                    HStack {
                        Text("First Name")
                        Spacer()
                        if isEditing {
                            TextField("Enter First Name", text: $editedUser.firstName)
                                .multilineTextAlignment(.trailing)
                        } else {
                            Text(originalUser.firstName)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Last Name")
                        Spacer()
                        if isEditing {
                            TextField("Enter Last Name", text: $editedUser.lastName)
                                .multilineTextAlignment(.trailing)
                        } else {
                            Text(originalUser.lastName)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(originalUser.email)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Role")
                        Spacer()
                        Text(OrgRole.uiName(for: originalUser.org.role))
                            .foregroundColor(.secondary)
                    }
                }
                
            }
            .listSectionSpacing(12)
            .contentMargins(.vertical, 12)
        }
        .navigationTitle("Account")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if isEditing {
                        updateProfile()
                    }
                    isEditing.toggle()
                    
                    //MARK: - Turn On Editting Mode
                }) {
                    if updateState == .loading {
                        ProgressView()
                    } else {
                        Text(isEditing ? "Done" : "Edit")
                            .font(.system(size: 17, weight: isEditing ? .semibold : .regular))
                    }
                }
            }
        }
        .alert(isPresented: $updateErrorAlertPresented) {
            Alert(
                title: Text("Update Failed"),
                message: Text(updateErrorMessage)
            )
        }
        .alertButtonTint(color: .teal)
    }
    
    private func updateProfile() {
        // Set state to loading when update begins
        updateState = .loading
        
        // Perform API call to update the user profile
        // Simulating a failed update for demonstration purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // If successful, set state to success and update originalUser
            let success = false // Replace with the logic to determine success
            
            if success {
                originalUser = editedUser
                updateState = .success
            } else {
                // If failed, set state to failed and provide error message
                let errorMessage = "Failed to update user profile" // Replace with the actual error message
                updateState = .failed(error: errorMessage)
                updateErrorMessage = errorMessage
                updateErrorAlertPresented.toggle()
            }
        }
    }
}


#Preview {
    NavigationView {
        AccountView(profileData: ProfileData())
    }
    .navigationViewStyle(StackNavigationViewStyle())
}
