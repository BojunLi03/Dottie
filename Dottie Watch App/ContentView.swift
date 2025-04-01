//
//  ContentView.swift
//  Dottie Watch App
//
//  Created by Bojun Li on 3/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Wrap the main VStack in a NavigationView
        NavigationView {
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
                
                // NavigationLink to GlucoseGraphView
                NavigationLink(destination: GlucoseGraphView(glucoseDataManager: GlucoseDataManager())) {
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
            //.navigationTitle("Dottie Watch App") // Optional: Add a title for the navigation bar
        }
    }

    // Action to simulate connection to glucose monitor
    func connectToGlucoseMonitor() {
        // Future functionality to connect to a glucose monitor
        print("Connect to glucose monitor button tapped.")
    }
}

#Preview {
    ContentView()
}
