//
//  InviteMemberView.swift
//  TestProfileApp
//
//  Created by User on 2024-02-09.
//

import Foundation
import SwiftUI

struct InviteMemberView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var role: OrgRole = .directMember
    
    @State private var isMenuVisible = false
    
    var body: some View {
        NavigationView {
            Form {
                
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.accentColor, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .mask(Image(systemName: "person.fill.badge.plus").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 70)
                        )
                        .frame(width: 100, height: 70)
                        .padding(.top, 25)
                        
                        
                        Text("Invite Member")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.bottom, 8)
                            .padding(.top, -8)
                    }
                    Spacer()
                }
                .frame(height: 95)
                .listRowBackground(Color.clear)
                
                Section(header: Text("Account Details")) {
                    HStack {
                        Text("First Name")
                        TextField("Enter First Name", text: $firstName)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Last Name")
                        TextField("Enter Last Name", text: $lastName)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Email")
                        TextField("Enter Email", text: $email)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Role")
                        Spacer()
                        Menu(content: {
                            Button(action: {
                                role = .directMember
                            }) {
                                Text(OrgRole.uiName(for: .directMember))
                            }
                            
                            Button(action: {
                                role = .admin
                            }) {
                                Text(OrgRole.uiName(for: .admin))
                            }
                        }, label: {
                            Text(OrgRole.uiName(for: role))
                        })
                    }
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .listSectionSpacing(8)
            .contentMargins(.vertical, -14)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                        
                        //MARK: - Invite New Member Logic
                        
                        
                    }) {
                        Text("Invite")
                            .font(.system(size: 17, weight: .regular))
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .font(.system(size: 17, weight: .regular))
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



#Preview {
    InviteMemberView()
}
