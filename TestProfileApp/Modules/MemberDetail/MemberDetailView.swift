//
//  MemberDetailView.swift
//  TestProfileApp
//
//  Created by User on 2024-02-09.
//

import Foundation
import SwiftUI

enum UpdateState: Equatable {
    case loading
    case success
    case failed(error: String)
}

struct MemberDetailView: View {
    
    var index: Int
    
    @State private var isEditing = false
    
    @StateObject var profileData: ProfileData
    
    @State private var originalMember: OrgMemberProfileModel
    @State private var editedMember: OrgMemberProfileModel
    
    @State private var updateState: UpdateState?
    @State private var updateErrorMessage: String = ""
    @State private var updateErrorAlertPresented: Bool = false
    
    init(index: Int, profileData: ProfileData) {
           self.index = index
           self._profileData = StateObject(wrappedValue: profileData)
           let member = profileData.organizationMembers.members[index]
           self._originalMember = State(initialValue: member)
           self._editedMember = State(initialValue: member)
       }
    
    
    var body: some View {
        ZStack {
            List {
                Section(header: Text("Account")) {
                    HStack {
                        Text("First Name")
                        Spacer()
                        if !isEditing {
                            Text(originalMember.firstName)
                                .foregroundStyle(Color.secondary)
                        } else {
                            TextField("Enter First Name", text: $editedMember.firstName)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    HStack {
                        Text("Last Name")
                        Spacer()
                        if !isEditing {
                            Text(originalMember.lastName)
                                .foregroundStyle(Color.secondary)
                        } else {
                            TextField("Enter Last Name", text: $editedMember.lastName)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        if !isEditing {
                            Text(originalMember.email)
                                .foregroundStyle(Color.secondary)
                        } else {
                            TextField("Enter Email", text: $editedMember.email)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    HStack {
                        Text("Role")
                        Spacer()
                        if !isEditing {
                            Text(OrgRole.uiName(for: originalMember.role))
                                .foregroundStyle(Color.secondary)
                        } else {
                            Menu(content: {
                                Button(action: {
                                    editedMember.role = .directMember
                                }) {
                                    Text(OrgRole.uiName(for: .directMember))
                                }
                                
                                Button(action: {
                                    editedMember.role = .admin
                                }) {
                                    Text(OrgRole.uiName(for: .admin))
                                }
                            }, label: {
                                Text(OrgRole.uiName(for: editedMember.role))
                            })
                        }
                    }
                }
                
                Section(header: Text("Devices")) {
                    ForEach(editedMember.sessionsList.sessions, id: \.id) { session in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(session.name)
                                .font(.system(size: 16, weight: .semibold))
                            Text(session.platform)
                                .font(.system(size: 14, weight: .regular))
                            Text("\(editedMember.firstName) \(editedMember.lastName) ∘ \(session.lastSeen == "Now" ? "online" : session.lastSeen)")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
                
                Section(header: Text("Dangerous Zone")) {
                    Button("Delete All Sessions", role: .destructive) {
                        
                        
                        //MARK: - Delete All Sessions Logic
                        
                        
                        
                    }
                    Button("Suspend", role: .destructive) {
                        
                        
                        
                        //MARK: - Suspend Member Logic
                        
                        
                    }
                    Button("Remove Member", role: .destructive) {
                        
                        
                        
                        //MARK: - Remove Member Logic
                        
                        
                        
                    }
                }
            }
            .listSectionSpacing(8)
            .contentMargins(.vertical, 2)
            
            if updateState == .loading {
                BaseLoadingView()
            }
        }
        .navigationTitle("Member")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if isEditing {
                        updateMember()
                    }
                    isEditing.toggle()
                    
                    
                    //MARK: - Turn On Editting Mode
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.system(size: 17, weight: isEditing ? .semibold : .regular))
                }
            }
        }
        .onAppear {
            if !isEditing {
                profileData.organizationMembers.members[index] = originalMember
            }
        }
        .onDisappear {
            if !isEditing {
                profileData.organizationMembers.members[index] = originalMember
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
    
    private func updateMember() {
        
        //MARK: - Update Member
        
        // Perform API call to update the member
        // If successful, replace originalMember with editedMember
        // Otherwise, show an alert to the user
        // Here you need to implement the logic to update the member
        
        
        
        // Set state to loading when update begins
        updateState = .loading
        
        // Perform API call to update the member
        // Simulating a failed update for demonstration purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // If successful, set state to success and update originalMember
            let success = false // Replace with the logic to determine success
            
            if success {
                originalMember = editedMember
                updateState = .success
            } else {
                // If failed, set state to failed and provide error message
                let errorMessage = "Failed to update member" // Replace with the actual error message
                updateErrorMessage = errorMessage
                
                updateState = .failed(error: errorMessage)
                updateErrorAlertPresented.toggle()
            }
        }
    }
}



#Preview {
    NavigationView {
        MemberDetailView(index: 0, profileData: ProfileData())
    }
    .navigationViewStyle(StackNavigationViewStyle())
}
