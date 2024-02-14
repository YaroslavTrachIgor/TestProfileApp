//
//  BaseLoadingView.swift
//  TestProfileApp
//
//  Created by User on 2024-02-13.
//

import Foundation
import SwiftUI

struct BaseLoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .padding()
        }
        .background(Color(.secondarySystemBackground).opacity(0.8))
        .cornerRadius(6)
    }
}
