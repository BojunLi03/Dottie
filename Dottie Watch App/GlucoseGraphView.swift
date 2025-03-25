//
//  GlucoseGraphView.swift
//  Dottie
//
//  Created by Bojun Li on 3/25/25.
//

/*
import SwiftUI
import Charts

struct GlucoseData: Identifiable {
    var timestamp: String
    var level: Int
    var id = UUID()
}


struct GlucoseGraphView: View {
    // Sample glucose data
    let glucoseData: [GlucoseData] = [
        .init(timestamp: "08:00", level: 120),
        .init(timestamp: "09:00", level: 140),
        .init(timestamp: "10:00", level: 115),
        .init(timestamp: "11:00", level: 130),
        .init(timestamp: "12:00", level: 135)
    ]
    
    var body: some View {
        VStack {
            glucoseLevelsGraph
                .frame(height: 200)
                .padding()
        }
    }
    
    // Corrected glucoseLevelsGraph computed property
    var glucoseLevelsGraph: some View {
        Chart(glucoseData) {
            LineMark(
                x: .value("Time", $0.timestamp),
                y: .value("Glucose Level", $0.level)
            )
        }
    }
}
*/

import SwiftUI
import Charts

struct GlucoseGraphView: View {
    // This will store parsed glucose data from the simulated database
    @State private var glucoseData: [GlucoseData] = []
    
    // To show loading state
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            
            // Show loading state while data is being "fetched"
            if isLoading {
                ProgressView("Loading Data...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                glucoseLevelsGraph
                    .frame(height: 200)
                    .padding()
            }
        }
        .onAppear {
            simulateDatabaseFetch()
        }
    }
    
    // Function to simulate fetching glucose data from a "database"
    func simulateDatabaseFetch() {
        // Simulating a delay as if fetching data from a database
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
            // Simulated database data
            let simulatedData: [GlucoseData] = [
                //.init(timestamp: "03/11 08:00", level: 120),
                //.init(timestamp: "03/11 09:00", level: 140),
                .init(timestamp: "03/11 10:00", level: 115),
                .init(timestamp: "03/11 11:00", level: 130),
                .init(timestamp: "03/11 12:00", level: 135)
            ]
            
            // Update the UI on the main thread after the simulated fetch
            DispatchQueue.main.async {
                glucoseData = simulatedData
                isLoading = false
            }
        }
    }
    
    var glucoseLevelsGraph: some View {
        Chart(glucoseData) {
            LineMark(
                x: .value("Time", $0.timestamp),
                y: .value("Glucose Level", $0.level)
            )
        }.chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisValueLabel(
                    content: {
                        Text(value.as(String.self) ?? "")
                            //.font(.footnote)
                            .rotationEffect(.degrees(-65)) // Rotate labels to fit better
                            //.frame(width: 60) // Adjust width to avoid overlapping
                    }
                )
            }
        }
        
    }
}

struct GlucoseData: Identifiable {
    var timestamp: String
    var level: Int
    var id = UUID()
}

