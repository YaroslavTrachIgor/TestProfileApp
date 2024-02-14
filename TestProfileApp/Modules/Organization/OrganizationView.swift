//
//  OrganizationView.swift
//  TestProfileApp
//
//  Created by User on 2024-02-09.
//

import Foundation
import SwiftUI

struct OrganizationView: View {
    
    @ObservedObject var profileData: ProfileData
    
    var body: some View {
        List {
            Text(profileData.user.org.name)
                .font(.title)
                .bold()
                .padding(.leading, -10)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listSectionSpacing(0)
            
            Section {
                NavigationLink(destination: MembersView(profileData: profileData)) {
                    Text("Members")
                }
                if profileData.user.org.role == .billableAdmin {
                    NavigationLink(destination: Text("Somewhere")) {
                        Text("Licenses, Payments, Billing")
                    }
                }
            }
            .listSectionSpacing(0)
            Section {
                NavigationLink(destination: Text("Somewhere")) {
                    Text("Organization Support")
                }
            }
            .listSectionSpacing(52)
        }
        .navigationTitle("Organization")
        .toolbarTitleDisplayMode(.inline)
        .listSectionSpacing(22)
        .contentMargins(.vertical, 8)
    }
}



#Preview {
    OrganizationView(profileData: ProfileData())
}
