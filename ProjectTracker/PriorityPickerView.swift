//
//  PriorityPickerView.swift
//  ProjectTracker
//
//  Created by Arcticulate on 2024-02-16.
//

import SwiftUI

struct MobileTextView: View {
    let labelText: String
    init(_ labelText: String) {
        self.labelText = labelText
    }
    
    var body: some View {
#if os(iOS)
        Text(labelText)
        #endif
    }
}

#Preview {
    MobileTextView("Some text")
}
