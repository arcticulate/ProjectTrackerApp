//
//  ContentView.swift
//  ProjectTracker
//
//  Created by Arcticulate on 2024-02-11.
//

import SwiftUI

struct SidebarValue: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String = "Tickets"
    
    enum Menu: CaseIterable {
        case tickets
        case about
    }
}

struct ContentView: View {
    @Binding var model: Tracker
    @State private var visibility: NavigationSplitViewVisibility = .doubleColumn // Single selection.
    @State private var preferredCompact: NavigationSplitViewColumn = .sidebar // Compact layout.
    @State private var sidebarID: SidebarValue.ID? // Single selection.
    @State private var ticketID: Ticket.ID? // Single selection.
    @State private var ticketSelections: Set<Ticket.ID> = [] // Multiple selection.
    @State private var showNewTicketDialog: Bool = false
    @State private var ticketFilter: [Ticket] = []
    @FocusState private var ticketFocus: TicketPriority?
    @FocusState private var ticketFocusNav: SidebarValue.Menu?
    @FocusState private var isTicketFocused: Bool
    @FocusState private var isTicketNavFocused: Bool
    @State private var ticketPrioritySelection: TicketPriority = .undetermined
    @State private var tintedColor: Color = Color.blue
    var countTickets: Int { model.tickets.count }
    var undeterminedTickets: [Ticket] {
        model.tickets.filter { $0.priority == .undetermined }
    }
    var canWaitTickets: [Ticket] {
        model.tickets.filter { $0.priority == .canWait }
    }
    var fixNextTickets: [Ticket] {
        model.tickets.filter { $0.priority == .fixNextRelease }
    }
    var mustFixTickets: [Ticket] {
        model.tickets.filter { $0.priority == .mustFixNow }
    }
    
    private func checkSelection(priority: TicketPriority) {
        switch priority {
        case .undetermined:
            ticketFilter = undeterminedTickets
        case .canWait:
            ticketFilter = canWaitTickets
        case .fixNextRelease:
            ticketFilter = fixNextTickets
        case .mustFixNow:
            ticketFilter = mustFixTickets
        }
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility, preferredCompactColumn: $preferredCompact) {
           // MARK: SidebarView
            List(selection: $sidebarID) {
                Section("Main section") {
                    ForEach(model.sidebarItems) { ticket in
                        Label(ticket.title, systemImage: "note.text")
                            .badge(countTickets)
                    }
                }
            }.listStyle(.sidebar)
                .focusable(isTicketNavFocused)
                .focused($ticketFocusNav, equals: .tickets)
                .onAppear(perform: {
                    ticketFocus = .undetermined
                    ticketFocusNav = .tickets
                    // Set initial selection to first sidebar entry, on app startup.
                    guard let item = model.sidebarItems.first else { return }
                    sidebarID = item.id
                })
        } content: {
            // MARK: Middle pane
            if sidebarID != nil {
                Group {
                    List(selection: $ticketID) {
                        // MARK: Undetermined
                        TicketSection(title: "Undetermined", tickets: undeterminedTickets, selection: $ticketID)
                        // MARK: Can wait section
                        TicketSection(title: "Can wait", tickets: canWaitTickets, selection: $ticketID)
                        // MARK: Fix next release section
                        TicketSection(title: "Fix next release", tickets: fixNextTickets, selection: $ticketID)
                        // MARK: Must Fix Now section
                        TicketSection(title: "Must fix now", tickets: mustFixTickets, selection: $ticketID)
                    }

                    .navigationTitle("\(model.tickets.count) tickets")
                }
                .toolbar {
                    ToolbarItem(id: "TBWizardNewTicket", placement: .automatic) {
                        Button {
                            showNewTicketDialog = true
                        } label: {
                            Label("Add wizard...", systemImage: "rectangle.badge.plus").labelStyle(.titleAndIcon)
                        }.sheet(isPresented: $showNewTicketDialog) {
                            NewTicketView(tickets: $model.tickets)
                        }
                    }
                    ToolbarItem(id: "TBAddTicket", placement: .primaryAction) {
                        Button {
                            model.tickets.append(Ticket(title: "Untitled"))
                        } label: {
                            Label("Add", systemImage: "plus")
                                .labelStyle(.titleAndIcon)
                        }.buttonStyle(.bordered)
                    }
                }
            }
        } detail: {
            if let ticketID = ticketID {
                TicketDetailsView(tickets: $model.tickets, id: ticketID)
                    .onChange(of: model.tickets.count) {
                        checkSelection(priority: ticketPrioritySelection)
                    }
            }
            else {
                   ContentUnavailableView(label: {
                       Image(systemName: "xmark.app").resizable()
                           .aspectRatio(contentMode: .fit)
                           .scaleEffect(0.5)
                       Text("Select an entry from the list")
                           .font(.title)
                           .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                   })
               
           }
        }.navigationSplitViewStyle(.automatic)
    }
}

struct TicketSection: View {
    let title: String
    let tickets: [Ticket]
    let edges = EdgeInsets(top: 7.5, leading: 10, bottom: 7.5, trailing: 10)
    /// Ticket ID as selection.
    @Binding var selection: Ticket.ID?
    @State private var ticket: Ticket = Ticket(title: "")
    
    var body: some View {
        Section(title) {
            if tickets.count > 0 {
                ForEach(tickets) { ticket in
                    HStack {
                        Label(
                            title: { Text(ticket.title) },
                            icon: { Image(systemName: ticket.prioritySymbol)
                                    .fontWeight(.bold)
                                    .symbolVariant(.none)
                                    .foregroundStyle(ticket.prioColor, .ultraThinMaterial)
                            })
                        Spacer()
                        Text(ticket.statusText)
                            .foregroundStyle(.secondary)
                        
                    }.listRowInsets(self.edges)
                }
               // .searchable(text: $ticket.title)
            }
            else {
                Text("No entries.")
                    .foregroundStyle(.secondary)
                    .font(.body)
                    .italic()
            }
        }
           
#if available
        .navigationBarTitleDisplayMode(.inline)
#endif
        .toolbarRole(.editor)
    }
}

#Preview {
    ContentView(model: .constant(Tracker()) )
}

#Preview("List row", traits: .fixedLayout(width: 400, height: 100)) {
    VStack {
        TicketSection(title: "Stuff", tickets: Ticket.examples, selection: .constant(UUID()))
    }.padding()
}
