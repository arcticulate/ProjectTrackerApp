//
//  NewTicketView.swift
//  ProjectTracker
//
//  Created by Arcticulate on 2024-02-22.
//

import SwiftUI

struct NewTicketView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var ticket: Ticket = Ticket()
    @State private var tempAppsList: String = ""
    @Binding var tickets: [Ticket]
    var format: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private func setOtherApps() {
        ticket.otherAppsRunning = tempAppsList.components(separatedBy: ",")
        print(ticket.otherAppsRunning)
    }
    
    var body: some View {
        NavigationStack {
            Text("New ticket").font(.title).padding()
            Form {
                Group {
                    TextField("Title", text: $ticket.title)
                    TextField("Datum", value: $ticket.datum, formatter: format).disabled(true)
                    #if os(iOS)
                        .foregroundStyle(.secondary)
                    #endif
                }
                #if os(macOS)
                .textFieldStyle(.roundedBorder)
                #endif
                #if os(macOS)
                Spacer().frame(height: 20)
                #endif
                Section {
                    TextEditor(text: $ticket.details)
                        .frame(height: 200)
                        .lineSpacing(5)
                    #if os(macOS)
                        .padding(.horizontal, 2.5)
                        .padding(.vertical, 7.5)
                        .border(Material.thick, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        .textFieldStyle(.roundedBorder)
                    #endif
                    TextField("Other apps", text: $tempAppsList)
                        .onSubmit {
                            setOtherApps()
                        }
                } header: {
                    Text("Details")
                } footer: {
                    Text("Separate app names with commas.").font(.caption)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        tickets.append(ticket)
                        setOtherApps()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
#if os(macOS)
        .frame(minWidth: 450, minHeight: 500)
        .padding()
#endif
        
    }
}

#Preview {
    NewTicketView(tickets: .constant(Ticket.examples))
}
