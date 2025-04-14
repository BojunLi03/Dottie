//
//  GlucoseDataManager.swift
//  Dottie
//
//  Created by Bojun Li on 3/31/25.
//


import Foundation
import SwiftUI

struct GlucoseData: Identifiable {
    var timestamp: String
    var level: Int
    var id = UUID()
}


class GlucoseDataManager: ObservableObject {
    @Published var glucoseData: [GlucoseData] = []//[.init(timestamp: "03/11 11:00", level: 120)]
    
    private var timer: Timer? = nil
    private let maxDataPoints = 4
    
    // Flag to indicate spike
    private var isSpiking = false

    func startRealTimeUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            let newData = self.generateRandomGlucoseData()
            self.glucoseData.append(newData)
            if self.glucoseData.count > self.maxDataPoints {
                self.glucoseData.removeFirst()
            }
        }
    }
    
    func simulateSpike() {
        isSpiking = !isSpiking
    }
    
    private let timeLabels: [String] = [
        "12PM", "1PM", "2PM", "3PM", "4PM", "5PM",
        "6PM", "7PM", "8PM", "9PM", "10PM", "11PM",
        "12AM", "1AM", "2AM", "3AM", "4AM", "5AM",
        "6AM", "7AM", "8AM", "9AM", "10AM", "11AM"
    ]
    private var currentTimeIndex: Int = 0
    
    private func getNextTimestamp() -> String {
        let label = timeLabels[currentTimeIndex]
        currentTimeIndex = (currentTimeIndex + 1) % timeLabels.count
        return label
    }
    
    private func generateRandomGlucoseData() -> GlucoseData {
        
        let timestamp = getNextTimestamp()
        var randomLevel: Int
        
        if let last = glucoseData.last {
            let lastLevel = last.level
            let lastWasSpiking = lastLevel >= 140  // Treat as spike if >= 140
            let currentIsSpiking = isSpiking

            if lastWasSpiking == currentIsSpiking {
                // Same state — keep it within ±10 of the last value
                let minValue = max(70, lastLevel - 15)
                let maxValue = min(220, lastLevel + 15)
                randomLevel = Int.random(in: minValue...maxValue)
            } else {
                // Transitioning between states — allow a jump
                if currentIsSpiking {
                    randomLevel = Int.random(in: 140...200)
                } else {
                    randomLevel = Int.random(in: 80...130)
                }
            }
        } else {
            // No previous value — start within normal range
            randomLevel = Int.random(in: 80...130)
        }

        // Clear spike flag after generation
        //isSpiking = false

        return GlucoseData(timestamp: timestamp, level: randomLevel)
    }

    
    private func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: Date())
    }

    func simulateDatabaseFetch() {
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

