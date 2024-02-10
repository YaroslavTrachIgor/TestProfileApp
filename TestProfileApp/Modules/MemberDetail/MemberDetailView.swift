//
//  MemberDetailView.swift
//  TestProfileApp
//
//  Created by User on 2024-02-09.
//

import Foundation
import SwiftUI

struct MemberDetailView: View {
    
    var index: Int
    
    @State private var isEditing = false
    
    @StateObject var profileData: ProfileData
    
    @State var edittedRole: OrgRole = .directMember
    @State var edittedFirstName = ""
    @State var edittedLastName = ""
    @State var edittedEmail = ""
    @State var edittedSessions: [UserSessionDisplay] = []
    
    
    var body: some View {
        List {
            Section(header: Text("Account")) {
                HStack {
                    Text("First Name")
                    Spacer()
                    if !isEditing {
                        Text(edittedFirstName)
                            .foregroundStyle(Color.secondary)
                    } else {
                        TextField("Enter First Name", text: $edittedFirstName)
                            .multilineTextAlignment(.trailing)
                    }
                }
                HStack {
                    Text("Last Name")
                    Spacer()
                    if !isEditing {
                        Text(edittedLastName)
                            .foregroundStyle(Color.secondary)
                    } else {
                        TextField("Enter Last Name", text: $edittedLastName)
                            .multilineTextAlignment(.trailing)
                    }
                }
                HStack {
                    Text("Email")
                    Spacer()
                    if !isEditing {
                        Text(edittedEmail)
                            .foregroundStyle(Color.secondary)
                    } else {
                        TextField("Enter Email", text: $edittedEmail)
                            .multilineTextAlignment(.trailing)
                    }
                }
                HStack {
                    Text("Role")
                    Spacer()
                    if !isEditing {
                        Text(OrgRole.uiName(for: edittedRole))
                            .foregroundStyle(Color.secondary)
                    } else {
                        Menu(content: {
                            Button(action: {
                                edittedRole = .directMember
                            }) {
                                Text(OrgRole.uiName(for: .directMember))
                            }
                            
                            Button(action: {
                                edittedRole = .admin
                            }) {
                                Text(OrgRole.uiName(for: .admin))
                            }
                        }, label: {
                            Text(OrgRole.uiName(for: edittedRole))
                        })
                    }
                }
            }
            
            Section(header: Text("Devices")) {
                ForEach(edittedSessions, id: \.id) { session in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.name)
                            .font(.system(size: 16, weight: .semibold))
                        Text(session.platform)
                            .font(.system(size: 14, weight: .regular))
                        Text("\(edittedFirstName) \(edittedLastName) ∘ \(session.lastSeen == "Now" ? "online" : session.lastSeen)")
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
        .navigationTitle("Member")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isEditing.toggle()
                    
                    
                    //MARK: - Turn On Editting Mode
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.system(size: 17, weight: isEditing ? .semibold : .regular))
                }
            }
        }
        .listSectionSpacing(8)
        .contentMargins(.vertical, 2)
        .onAppear {
            let member = profileData.organizationMembers.members[index]
            edittedRole = member.role
            edittedEmail = member.email
            edittedFirstName = member.firstName
            edittedLastName = member.lastName
            edittedSessions = member.sessionsList.sessions
        }
        .onDisappear {
            profileData.organizationMembers.members[index].role = edittedRole
            profileData.organizationMembers.members[index].email = edittedEmail
            profileData.organizationMembers.members[index].firstName = edittedFirstName
            profileData.organizationMembers.members[index].lastName = edittedLastName
            profileData.organizationMembers.members[index].name = "\(edittedFirstName) \(edittedLastName)"
            profileData.organizationMembers.members[index].sessionsList.sessions = edittedSessions
        }
    }
}
