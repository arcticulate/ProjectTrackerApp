//
//  AboutView.swift
//  ProjectTracker
//
//  Created by Tony Granberg on 2024-03-09.
//

import SwiftUI

struct AboutView: View {
    let appInfo: AppInfo
    
    var body: some View {
        VStack {
            Text("App information")
                .font(.title2)
                .fontWeight(.bold)
            Text("\(appInfo.buildName) \(appInfo.shortVersion) (Build \(appInfo.buildVersion))")
            
        }.frame(width: 300, height: 125).padding()
    }
}

#Preview {
    AboutView(appInfo: AppInfo())
}
