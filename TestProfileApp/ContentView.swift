//
//  ContentView.swift
//  TestProfileApp
//
//  Created by User on 2024-02-06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        UserMenuView()
    }
}


struct UserMenuView: View {
    
    @State var user = DataPreview.user
    
    var body: some View {
        NavigationView {
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
                        
                        
                        Text("Welcome, \(user.firstName)!")
                            .font(.system(size: 20, weight: .semibold))
                            .padding(.bottom, 8)
                            .padding(.top, -8)
                    }
                    Spacer()
                }
                .frame(height: 90)
                .listRowBackground(Color.clear)
                
                
                
                Section(header: Text("Account")) {
                    NavigationLink(destination: AccountView()) {
                        Text(user.email)
                    }
                    
                    if user.org.role == .admin || user.org.role == .billableAdmin {
                        NavigationLink(destination: OrganizationView()) {
                            Text(user.org.name)
                        }
                    }
                }
                
                Section(header: Text("Sessions"), footer: Text("Swipe to remove a device. The device will lose access to your account.")) {
                    ForEach(user.sessions, id: \.id) { session in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(session.name)
                                .font(.system(size: 16, weight: .semibold))
                            Text(session.platform)
                                .font(.system(size: 14, weight: .regular))
                            Text("\(user.firstName) \(user.lastName) ∘ \(session.lastSeen == "Now" ? "online" : session.lastSeen)")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button("Sign Out", role: .destructive) {
                            
                        }
                        Spacer()
                    }
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .listSectionSpacing(12)
            .contentMargins(.vertical, 0)
        }
    }
}



struct AccountView: View {
    
    @State private var isEditing = false
    @State private var editedUser = DataPreview.user
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("First Name")
                    Spacer()
                    if isEditing {
                        TextField("Enter First Name", text: $editedUser.firstName)
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text(editedUser.firstName)
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
                        Text(editedUser.lastName)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Text(editedUser.email)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Role")
                    Spacer()
                    Text(OrgRole.uiName(for: editedUser.org.role))
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



struct OrganizationView: View {
    
    @State private var user = DataPreview.user
    
    var body: some View {
        List {
            Section(header: Text(user.org.name)) {
                NavigationLink(destination: MembersView()) {
                    Text("Members")
                }
                if user.org.role == .billableAdmin {
                    NavigationLink(destination: Text("Somewhere")) {
                        Text("Licenses, Payments, Billing")
                    }
                }
            }
            Section {
                NavigationLink(destination: Text("Somewhere")) {
                    Text("Organization Support")
                }
            }
        }
        .navigationTitle("Organization")
        .toolbarTitleDisplayMode(.inline)
        .listSectionSpacing(32)
        .contentMargins(.vertical, 0)
    }
}


struct MembersView: View {
    
    @State private var organizationMembers = DataPreview.organizationMembers.members
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
                    return organizationMembers
                } else {
                    return organizationMembers.filter { $0.state == .invited }
                }
            } else {
                if selectedMemberType == 0 {
                    return organizationMembers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                } else {
                    return organizationMembers.filter { $0.name.localizedCaseInsensitiveContains(searchText) && $0.state == .invited }
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
                ForEach(filteredMembers, id: \.id) { organizationMember in
                    NavigationLink(destination: MemberInfoView(memberProfile: organizationMember)) {
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
        .searchable(text: $searchText, prompt: "Search Members")
        .sheet(isPresented: $presentInviteView) {
            InviteMemberView()
        }
    }
}


struct InviteMemberView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var roleButtonTitle: String = "Direct Member"
    @State var role: OrgRole = .directMember
    
    @State private var isMenuVisible = false
    
    var body: some View {
        NavigationView {
            List {
                
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
    }
}



struct MemberInfoView: View {
    
    @State private var isEditing = false
    
    @State var memberProfile: OrgMemberProfileModel
    
    @State var edittedRole: OrgRole = .directMember
    @State var edittedFirstName = ""
    @State var edittedLastName = ""
    @State var edittedEmail = ""
    
    
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
                ForEach(memberProfile.sessionsList.sessions, id: \.id) { session in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.name)
                            .font(.system(size: 16, weight: .semibold))
                        Text(session.platform)
                            .font(.system(size: 14, weight: .regular))
                        Text("\(memberProfile.firstName) \(memberProfile.lastName) ∘ \(session.lastSeen == "Now" ? "online" : session.lastSeen)")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
            
            Section(header: Text("Dangerous Zone")) {
                Button("Delete All Sessions", role: .destructive) {
                    
                }
                Button("Suspend", role: .destructive) {
                    
                }
                Button("Remove Member", role: .destructive) {
                    
                }
            }
        }
        .navigationTitle("Member")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.system(size: 17, weight: isEditing ? .semibold : .regular))
                }
            }
        }
        .listSectionSpacing(8)
        .contentMargins(.vertical, 2)
        .onAppear {
            edittedRole = memberProfile.role
            edittedLastName = memberProfile.lastName
            edittedFirstName = memberProfile.firstName
            edittedEmail = memberProfile.email
        }
    }
}


#Preview {
    NavigationView {
        MemberInfoView(memberProfile: DataPreview.organizationMembers.members[0])
    }
}
