//
//  GlucoseGraphView.swift
//  Dottie
//
//  Created by Bojun Li on 3/25/25.
//

import SwiftUI
import Charts

struct GlucoseGraphView: View {
    // This will be our GlucoseDataManager that handles data operations
    @ObservedObject var glucoseDataManager: GlucoseDataManager
    
    // State variable to manage loading state
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
            // Start real-time updates and stop the loading screen once the data starts
            glucoseDataManager.startRealTimeUpdates()
            
            // Simulate fetching data and stop loading once data is added
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Wait for a couple of seconds before changing the loading state
                self.isLoading = false
            }
        }
    }
    
    var glucoseLevelsGraph: some View {
        Chart(glucoseDataManager.glucoseData) {
            LineMark(
                x: .value("Time", $0.timestamp),
                y: .value("Glucose Level", $0.level)
            )
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisValueLabel(
                    content: {
                        Text(value.as(String.self) ?? "")
                            .rotationEffect(.degrees(-65)) // Rotate labels to fit better
                    }
                )
            }
        }
    }
}
