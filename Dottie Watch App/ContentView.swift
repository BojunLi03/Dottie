//
//  ContentView.swift
//  Dottie Watch App
//
//  Created by Bojun Li on 3/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Button to connect to glucose monitor
            Button(action: {
                connectToGlucoseMonitor()
            }) {
                Text("Connect to Glucose Monitor")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // Button to view glucose levels
            Button(action: {
                viewGlucoseLevels()
            }) {
                Text("View Glucose Levels")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    // Action to simulate connection to glucose monitor
    func connectToGlucoseMonitor() {
        // Future functionality to connect to a glucose monitor
        print("Connect to glucose monitor button tapped.")
    }
    
    // Action to simulate viewing glucose levels
    func viewGlucoseLevels() {
        // Future functionality to view glucose levels
        print("View glucose levels button tapped.")
    }
}

#Preview {
    ContentView()
}
