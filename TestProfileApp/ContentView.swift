//
//  ContentView.swift
//  TestProfileApp
//
//  Created by User on 2024-02-06.
//

import SwiftUI

struct ContentView: View {
    
    @State var presentProfileMenuView = false
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.systemTeal
    }
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            VStack {
                Button("Present Profile Menu View on iPad") {
                    presentProfileMenuView.toggle()
                }
            }
            .sheet(isPresented: $presentProfileMenuView) {
                NavigationView {
                    UserMenuView()
                }
            }
            
        } else {
            NavigationView {
                NavigationLink {
                    UserMenuView()
                } label: {
                    Text("Present Profile Menu View on iPhone")
                        .foregroundStyle(Color.blue)
                }
            }
        }
    }
}
