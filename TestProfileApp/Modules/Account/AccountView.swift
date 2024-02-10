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
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("First Name")
                    Spacer()
                    if isEditing {
                        TextField("Enter First Name", text: $profileData.user.firstName)
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text(profileData.user.firstName)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Text("Last Name")
                    Spacer()
                    if isEditing {
                        TextField("Enter Last Name", text: $profileData.user.lastName)
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text(profileData.user.lastName)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Text(profileData.user.email)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Role")
                    Spacer()
                    Text(OrgRole.uiName(for: profileData.user.org.role))
                        .foregroundColor(.secondary)
                }
            }
            
        }
        .navigationTitle("Account")
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
        .listSectionSpacing(12)
        .contentMargins(.vertical, 12)
    }
}
