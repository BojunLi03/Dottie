//
//  GlucoseDataManager.swift
//  Dottie
//
//  Created by Bojun Li on 3/31/25.
//


// GlucoseDataManager.swift

import Foundation
import SwiftUI

class GlucoseDataManager: ObservableObject {
    // This will store the glucose data (only the last few timestamps)
    @Published var glucoseData: [GlucoseData] = [.init(timestamp: "03/11 08:00", level: 10),
                                                 .init(timestamp: "03/11 09:00", level: 20),
                                                 .init(timestamp: "03/11 10:00", level: 10),
                                                 .init(timestamp: "03/11 11:00", level: 40)]
    
    // Timer for real-time updates
    private var timer: Timer? = nil
    
    // Maximum number of data points to display
    private let maxDataPoints = 4
    
    // Start real-time data updates
    func startRealTimeUpdates() {
        // Start a timer that adds data every 60 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            // Generate a new random glucose level with the current timestamp
            let newData = self.generateRandomGlucoseData()
            
            // Add the new data to the glucoseData array
            self.glucoseData.append(newData)
            
            // Optionally, limit the number of data points to the last few (maxDataPoints)
            if self.glucoseData.count > self.maxDataPoints {
                self.glucoseData.removeFirst()  // Remove the oldest data point if the limit is exceeded
            }
        }
    }
    
    // Function to generate random GlucoseData with the current timestamp
    private func generateRandomGlucoseData() -> GlucoseData {
        // Generate a random glucose level between 70 and 180 (e.g., mg/dL)
        let randomLevel = Int.random(in: 70...180)
        
        // Get the current timestamp as a formatted string
        let timestamp = getCurrentTimestamp()
        
        return GlucoseData(timestamp: timestamp, level: randomLevel)
    }
    
    // Function to get the current timestamp as a string
    private func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"  // Format like "03/11 15:45"
        return formatter.string(from: Date())
    }
    
    // Optional: Simulate database fetch if you want to load initial data
    func simulateDatabaseFetch() {
        // Simulated initial data to load
        let initialData: [GlucoseData] = [
            .init(timestamp: "03/11 08:00", level: 120),
            .init(timestamp: "03/11 09:00", level: 140),
            .init(timestamp: "03/11 10:00", level: 115),
            .init(timestamp: "03/11 11:00", level: 130),
            .init(timestamp: "03/11 12:00", level: 135)
        ]
        
        for (index, data) in initialData.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.0) {
                self.glucoseData.append(data)
            }
        }
    }
}

struct GlucoseData: Identifiable {
    var timestamp: String
    var level: Int
    var id = UUID()
}
