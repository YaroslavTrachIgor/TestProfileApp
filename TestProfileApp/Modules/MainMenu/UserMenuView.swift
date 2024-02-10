//
//  UserMenuView.swift
//  TestProfileApp
//
//  Created by User on 2024-02-09.
//

import Foundation
import SwiftUI

struct UserMenuView: View {
    
    @StateObject private var profileData = ProfileData()
    
    var body: some View {
        List {
            
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.red, Color.teal]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .mask(Image(systemName: "person.3.fill").resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    )
                    .frame(width: 100, height: 70)
                    .padding(.top, 25)
                    
                    
                    Text("Welcome, \(profileData.user.firstName)!")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.bottom, 8)
                        .padding(.top, -8)
                }
                Spacer()
            }
            .frame(height: 90)
            .listRowBackground(Color.clear)
            
            
            
            Section(header: Text("Account")) {
                NavigationLink(destination: AccountView(profileData: profileData)) {
                    Text(profileData.user.email)
                }
                
                if profileData.user.org.role == .admin || profileData.user.org.role == .billableAdmin {
                    NavigationLink(destination: OrganizationView(profileData: profileData)) {
                        Text(profileData.user.org.name)
                    }
                }
            }
            
            Section(header: Text("Sessions"), footer: Text("Swipe to remove a device. The device will lose access to your account.")) {
                ForEach(profileData.user.sessions, id: \.id) { session in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.name)
                            .font(.system(size: 16, weight: .semibold))
                        Text(session.platform)
                            .font(.system(size: 14, weight: .regular))
                        Text("\(profileData.user.name) ∘ \(session.lastSeen == "Now" ? "online" : session.lastSeen)")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.secondary)
                    }
                }
                .onDelete(perform: removeRows)
            }
            
            Section {
                HStack {
                    Spacer()
                    Button("Sign Out", role: .destructive) {
                        
                        //MARK: - Sign OUT Logic
                    }
                    Spacer()
                }
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .listSectionSpacing(12)
        .contentMargins(.vertical, 0)
    }
    
    func removeRows(at offsets: IndexSet) {
        profileData.user.sessions.remove(atOffsets: offsets)
        
        //MARK: - Delete sessions logic
    }
}
