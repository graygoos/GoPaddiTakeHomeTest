//
//  ContentView.swift
//  GoPaddiTakeHomeTest
//
//  Created by Femi Aliu
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


/*
 before uploading to GitHub/TestFlight:
 - organise files/folders - new files/folders where necessary
 - comment code/ DocC / etc - remove comments
 - make sure code is properly structured
 - remove extraneous comments
 - info.plist - request permissions
 - sheet when app first loads - onboarding?
 - remove dates from Xcode header comments from all files
 - update deprecated modifiers, NavigationView etc
 - delete extraneous code and files
 - freepik attributions
 
 delete this file
 */
