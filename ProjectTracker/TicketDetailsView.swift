//
//  TicketDetailsView.swift
//  ProjectTracker
//
//  Created by Arcticulate on 2024-02-11.
//

import SwiftUI

struct TextRows: View {
    var radius: CGSize = CGSize(width: 6, height: 6)
    var separator: String = ","
    let id: Ticket.ID?
    let isEditing: Bool
    @Binding var tickets: [Ticket]
    
    var body: some View {
        if let index = tickets.firstIndex(where: { $0.id == id }) {
            VStack(alignment: .leading) {
                if isEditing {
                    Form {
                        TextField("Title", text: $tickets[index].title)
                        
                        Picker("Category", selection: $tickets[index].category) {
                            ForEach(TicketCategory.allCases, id: \.self) { ticket in
                                Text(ticket.rawValue)
                                    .tag(ticket.rawValue)
                            }
                        }
                        
                        Picker("Ticket status", selection: $tickets[index].status) {
                            ForEach(Status.allCases, id: \.self) { status in
                                Text(status.rawValue)
                                    .tag(status.rawValue)
                            }
                        }
                        
                        Picker("Ticket platform", selection: $tickets[index].platformOS) {
                            ForEach(TicketPlatform.allCases, id: \.self) { platform in
                                Text(platform.rawValue)
                                    .tag(platform.rawValue)
                            }
                        }
                        
                        Section(content: {}, header: { MobileTextView("Priority") }, footer: {
                            Picker(selection: $tickets[index].priority) {
                                ForEach(TicketPriority.allCases, id: \.self) { priority in
                                    Text(priority.rawValue)
                                        .tag(priority.rawValue)
                                }
                            } label: {
#if os(macOS)
                                Text("Priority")
#endif
                            }
                            .pickerStyle(.palette)
                        })
                        
                        
                        // MARK: Description text area
                        Section("Description") {
                            TextEditor(text: $tickets[index].details)
                            #if os(iOS)
                                .frame(minHeight: 200)
                            #endif
                        }
                    }
                    #if os(macOS)
                    .frame(maxWidth: 460)
                    #endif
                }
                // MARK: Not editing (read-only view)
                else {
                    VStackLayout(alignment: .leading) {
                        // MARK: Second stack
                        GroupBox {
                            HStack {
                                Text("Category").font(.headline)
                                Text(tickets[index].categoryText).foregroundStyle(.primary)
                                Spacer()
                                Text("Priority").font(.headline)
                                PriorityProgressView(ticket: tickets[index])
                                    .frame(width: 120)
                            }.frame(maxHeight: 25)
                        }
                        // -->
                        Spacer()
                        HStack {
                            VStack(alignment: .leading) {
                                Text(tickets[index].title).foregroundStyle(.secondary)
                                Text("\(tickets[index].datum.formatted()) (\(tickets[index].datumCreatedRelative))")
                                    .foregroundStyle(.tertiary)
                            }.padding()
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Status").foregroundStyle(.secondary)
                                Text(tickets[index].statusText)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        Divider()
                        Text("**Operating system:** \(tickets[index].platformText)")
                        // TODO: Add picker above in the isEditing section: Checkbox/flip switch to choose apps running, plus separe TextField for "Other apps" free-text input.
                        Text("**Other apps running:** \(tickets[index].otherAppsRunning.formatted(.list(type: .and)))")
                        Divider()
                        Text("**Describe what you were doing before the incident happened:**")
                        Text(tickets[index].details).font(.body)
                        Divider()
                        Spacer()
                    }
                    .padding()
                    .background(
                        //Color.blue,
                        ignoresSafeAreaEdges: .all)
                }
            }.padding()
        }
    }
}

struct TicketDetailsView: View {
    @State private var isEditing: Bool = false
    @Binding var tickets: [Ticket]
    let id: Ticket.ID?
    
    var body: some View {
        VStack(alignment: .leading) {
            TextRows(id: id, isEditing: isEditing, tickets: $tickets)
        }
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem {
                Spacer()
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    isEditing.toggle()
                } label: {
                    Label(isEditing ? "Save" : "Edit", systemImage: "pencil")
                        .labelStyle(.titleAndIcon)
                }.buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    // MARK: Dark mode
    ViewThatFits {
        TicketDetailsView(tickets: .constant(Ticket.examples), id: Ticket.examples.first!.id)
            .frame(minHeight: 250)
    }
}

