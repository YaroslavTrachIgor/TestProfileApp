//
//  ProfileModels.swift
//  TestProfileApp
//
//  Created by User on 2024-02-06.
//

import Foundation

struct UserProfileModel {
    var id: UUID
    var name: String
    var firstName: String
    var lastName: String
    var created: Date
    var updated: Date
    var email: String
    var org: UserOrgMemberInfo
    var sessions: [UserSessionDisplay]
}

struct UserOrgMemberInfo {
    var name: String
    var orgId: UUID
    var state: UserState
    var role: OrgRole
}

enum OrgRole: String {
    case billableAdmin = "billable_admin"
    case admin = "admin"
    case directMember = "direct_member"
    
    static func uiName(for role: OrgRole) -> String {
        switch role {
        case .billableAdmin:
            "Billable Admin"
        case .admin:
            "Admin"
        case .directMember:
            "Direct Member"
        }
    }
}

enum UserState: String {
    case invited
    case active
    case inactive
    case suspended
}

struct OrgProfileModel {
    var name: String
    var created: Date
    var updated: Date
}

struct OrgMemberProfileModel: Identifiable {
    var role: OrgRole
    var state: UserState
    var id: UUID
    var name: String
    var firstName: String
    var lastName: String
    var created: Date
    var updated: Date
    var email: String
    var sessionsList: UserSessionsList
}

struct UserSessionDisplay: Identifiable {
    var id: UUID
    var platform: String
    var lastSeen: String
    var name: String
}

struct UserSessionsList {
    var sessions: [UserSessionDisplay]
}

struct OrgMembersList {
    var members: [OrgMemberProfileModel]
}

final class DataPreview {
    static var organization = OrgProfileModel(name: "Acme, Inc", created: date("2023-01-01T12:00:00Z"), updated: date("2023-12-31T18:30:00Z"))
    
    static var user = UserProfileModel(id: UUID(),
                                       name: "Eva Chen",
                                       firstName: "Eva",
                                       lastName: "Chen",
                                       created: date("2023-06-15T13:20:00Z"),
                                       updated: date("2023-12-10T16:05:00Z"),
                                       email: "eva.chen@acme.com",
                                       org: UserOrgMemberInfo(name: "Acme, Inc.",
                                                              orgId: UUID(),
                                                              state: .active,
                                                              role: .billableAdmin),
                                       sessions: userSessions.sessions)
    
    static var userSessions = UserSessionsList(sessions: [UserSessionDisplay(id: UUID(), platform: "iOS 17.1", lastSeen: "Now", name: "iPad Pro")])
    
    static var organizationMembers = OrgMembersList(
        members:
            [
                OrgMemberProfileModel(role: .directMember,
                                      state: .active,
                                      id: UUID(),
                                      name: "Jane Doe",
                                      firstName: "Jane",
                                      lastName: "Doe",
                                      created: Date(),
                                      updated: Date(),
                                      email: "jane@acme.com", 
                                      sessionsList: UserSessionsList(sessions: [
                                        UserSessionDisplay(id: UUID(), platform: "iOS 17.1", lastSeen: "Now", name: "iPad Pro"),
                                        UserSessionDisplay(id: UUID(), platform: "iOS 17.2", lastSeen: "14 January, 2024", name: "iPhone 14 Pro")
                                      ])),
                OrgMemberProfileModel(role: .billableAdmin,
                                      state: .active,
                                      id: UUID(),
                                      name: "Eva Chen",
                                      firstName: "Eva",
                                      lastName: "Chen",
                                      created: Date(),
                                      updated: Date(),
                                      email: "eva@acme.com", 
                                      sessionsList: UserSessionsList(sessions: [
                                        UserSessionDisplay(id: UUID(), platform: "iOS 17.1", lastSeen: "10 February, 2024", name: "iPad Pro")
                                      ])),
                OrgMemberProfileModel(role: .directMember,
                                      state: .invited,
                                      id: UUID(),
                                      name: "David Laid",
                                      firstName: "David",
                                      lastName: "Laid",
                                      created: Date(),
                                      updated: Date(),
                                      email: "david@acme.com",
                                      sessionsList: UserSessionsList(sessions: [
                                        UserSessionDisplay(id: UUID(), platform: "iOS 17.1", lastSeen: "Now", name: "iPad Pro"),
                                        UserSessionDisplay(id: UUID(), platform: "iOS 17.2", lastSeen: "17 December, 2023", name: "iPhone 15 Pro Max")
                                      ])),
            ]
    )
    
    static func date(_ dateString: String) -> Date {
        ISO8601DateFormatter().date(from: dateString)!
    }
}
