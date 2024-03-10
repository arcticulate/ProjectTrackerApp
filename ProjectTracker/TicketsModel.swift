//
//  TicketsModel.swift
//  ProjectTracker
//
//  Created by Arcticulate on 2024-02-11.
//

import SwiftUI

struct AppInfo {
    var shortVersion: String {
        let test = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        return test
    }
    
    var buildVersion: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    
    var buildName: String {
        Bundle.main.infoDictionary?["CFBundleName"] as! String
    }
    
    var iconName: String {
            Bundle.main.infoDictionary?["CFBundleIconName"] as! String
    }
}

/// Tracker model: stores multiple tickets.
struct Tracker: Identifiable, Codable {
    var id: UUID = UUID()
    var tickets: [Ticket] = [
        Ticket(title: "Example"), Ticket(title: "Issue", otherAppsRunning: ["Xcode", "Safari"]),
        Ticket(title: "New feature", platformOS: .mac, category: .featureRequest, priority: .fixNextRelease),
        Ticket(title: "Menu not working", platformOS: .mac, category: .issueFound, priority: .mustFixNow),
        Ticket(title: "Glitch", platformOS: .pad, category: .issueFound, priority: .mustFixNow),
    ]
    var sidebarItems: [SidebarValue] = [SidebarValue()]
}

enum TicketCategory: String, Hashable, Codable, CaseIterable {
    case featureRequest
    case issueFound
    case notSelected
}

/// Ticket priority.
enum TicketPriority: String, Hashable, Codable, CaseIterable {
    case undetermined
    case canWait
    case fixNextRelease
    case mustFixNow
}

enum TicketPlatform: String, Hashable, Codable, CaseIterable {
    case mac
    case phone
    case pad
    case tv
}



/// Ticket model.
struct Ticket: Identifiable, Hashable, Equatable, Codable {
    var id: UUID = UUID()
    var datum: Date = Date.now
    var datumCreatedRelative: String { datum.formatted(.relative(presentation: .named)) }
    var title: String = ""
    var details: String = "The problem that was encountered, thus reported using this form."
    /// Other apps running in the background when the issue was found.
    var otherAppsRunning: [String] = []
    var platformOS: TicketPlatform = .mac
    var platformText: String {
        switch platformOS {
        case .mac:
            return NSLocalizedString("macOS", comment: "Mac OS.")
        case .phone:
            return NSLocalizedString("iOS", comment: "iOS on iPhone.")
        case .pad:
            return NSLocalizedString("iPadOS", comment: "iPad OS.")
        case .tv:
            return NSLocalizedString("tvOS", comment: "tv OS on Apple TV.")
        }
    }
    var status: Status = .open
    /// Ticket category.
    var category: TicketCategory = .notSelected
    /// Ticket priority.
    var priority: TicketPriority = .undetermined
    var prioColor: Color {
        switch priority {
        case .undetermined:
            return Color.secondary
        case .canWait:
            return Color.green
        case .fixNextRelease:
            return Color.yellow
        case .mustFixNow:
            return Color.red
        }
    }
    var categoryText: String {
        switch category {
        case .featureRequest:
            return NSLocalizedString("Feature Request", comment: "Feature request.")
        case .issueFound:
            return NSLocalizedString("Issue Found", comment: "An issue was found.")
        case .notSelected:
            return NSLocalizedString("N/A", comment: "No category selected.")
        }
    }
    var priorityText: String {
        switch priority {
        case .undetermined:
            return NSLocalizedString("Undetermined", comment: "Undetermined priority.")
        case .canWait:
            return NSLocalizedString("Can wait", comment: "Fixes for this issue can wait.")
        case .fixNextRelease:
            return NSLocalizedString("Next release", comment: "A fix is planned for the next release.")
        case .mustFixNow:
            return NSLocalizedString("Blocker", comment: "This issue is a blocker. Affects the stability of the app.")
        }
    }
    
    var prioritySymbol: String {
        switch priority {
        case .undetermined:
            return "note.text"
        case .canWait:
            return "hand.raised"
        case .fixNextRelease:
            return "arrow.right"
        case .mustFixNow:
            return "xmark"
        }
    }
    
    var statusText: String {
        switch status {
        case .open:
            NSLocalizedString("Open", comment: "Open issue")
        case .pendingSolution:
            NSLocalizedString("Pending", comment: "Issue pending a solution")
        case .closed:
            NSLocalizedString("Closed", comment: "Closed issue")
        }
    }
    static let example: Ticket = Ticket(title: "Example", details: "Detailed description text.")
    static let examples: [Ticket] = [
        Ticket(title: "Example", details: "Detailed description text.", priority: .fixNextRelease),
        Ticket(title: "Example 2", details: "MoreDdetailed description here.", priority: .mustFixNow),
        ]
}

/// Ticket status.
enum Status: String, Codable, CaseIterable {
    case open
    case pendingSolution
    case closed
}
