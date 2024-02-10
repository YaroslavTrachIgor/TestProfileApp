//
//  MembersView.swift
//  TestProfileApp
//
//  Created by User on 2024-02-09.
//

import Foundation
import SwiftUI

struct MembersView: View {
    
    @ObservedObject var profileData: ProfileData
    
    @State private var selectedMemberType: Int = 0
    @State private var searchText: String = ""
    
    @State private var presentInviteView: Bool = false
    
    var membersSectionHeader: String {
        if searchText.isEmpty {
            if selectedMemberType == 0 {
                return "All Members"
            } else {
                return "Invited Members"
            }
        } else {
            return "Search Results"
        }
    }
    
    var filteredMembers: [OrgMemberProfileModel] {
            if searchText.isEmpty {
                if selectedMemberType == 0 {
                    return profileData.organizationMembers.members
                } else {
                    return profileData.organizationMembers.members.filter { $0.state == .invited }
                }
            } else {
                if selectedMemberType == 0 {
                    return profileData.organizationMembers.members.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.email.localizedCaseInsensitiveContains(searchText) }
                } else {
                    return profileData.organizationMembers.members.filter { ($0.name.localizedCaseInsensitiveContains(searchText) || $0.email.localizedCaseInsensitiveContains(searchText)) && $0.state == .invited }
                }
            }
        }
    
    
    
    var body: some View {
        List {
            Picker("Members", selection: $selectedMemberType) {
                Text("All").tag(0)
                Text("Invited").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, -20)
            .padding(.vertical, -20)
            .listRowBackground(Color.clear)
            
            Section(header: Text(membersSectionHeader)) {
                ForEach(0..<filteredMembers.count, id: \.self) { index in
                    let organizationMember = filteredMembers[index]
                    NavigationLink(destination: MemberDetailView(index: index, profileData: profileData)) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(organizationMember.name)
                                .foregroundStyle(Color(.label))
                                .font(.system(size: 18, weight: .semibold))
                            Text(OrgRole.uiName(for: organizationMember.role))
                                .foregroundStyle(Color(.label))
                                .font(.system(size: 15, weight: .regular))
                            Text(organizationMember.email)
                                .foregroundStyle(Color(.secondaryLabel))
                                .font(.system(size: 15, weight: .regular))
                        }
                    }
                    .tag(index)
                }
            }
        }
        .navigationTitle("Members")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    presentInviteView.toggle()
                }) {
                    Text("Invite")
                        .font(.system(size: 17, weight: .regular))
                }
            }
        }
        .listSectionSpacing(6)
        .contentMargins(.vertical, 2)
        .sheet(isPresented: $presentInviteView) {
            InviteMemberView()
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search Members")
    }
}
