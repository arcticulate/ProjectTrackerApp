//
//  PriorityProgressView.swift
//  ProjectTracker
//
//  Created by Arcticulate on 2024-02-22.
//

import SwiftUI


struct PriorityProgressView: View {
    let ticket: Ticket
 
    var body: some View {
        HStack {
            Grid {
                GridRow {
                    GridRectangle(text: ticket.priorityText, color: ticket.prioColor)
                }
            }
        }
    }
}

#Preview {
    PriorityProgressView(ticket: Ticket.example)
}

struct GridRectangle: View {
    let text: String
    let color: Color
    let corners: CGSize = CGSize(width: 4, height: 4)
    let borderWidth = 1.0
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerSize: corners)
                .zIndex(1.0)
                .foregroundStyle(color)
            Text(text)
                .zIndex(2.0)
                .foregroundStyle(colorScheme == .dark ? .black : .white)
                .font(.system(.headline, design: .rounded, weight: .bold))
        }
    }
}
