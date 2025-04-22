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
    var verticalMarkerLabel: String = "" // "" = no line, otherwise draw
    var id = UUID()
}



class GlucoseDataManager: ObservableObject {
    @Published var glucoseData: [GlucoseData] = []//[.init(timestamp: "03/11 11:00", level: 120)]
    
    
    
    private var timer: Timer? = nil
    private let maxDataPoints = 7
    
    // Flag to indicate spike
    private var isSpiking = false
    private var isDropped = false

    func startRealTimeUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            let newData = self.generateGlucoseData()
            self.glucoseData.append(newData)
            if self.glucoseData.count > self.maxDataPoints {
                self.glucoseData.removeFirst()
            }
        }
    }
    
    func simulateSpike() {
        isSpiking = !isSpiking
        isDropped = false
    }
    
    func simulateDrops(){
        isDropped = !isDropped
        isSpiking = false
    }
    
    private let timeLabels: [String] = [
        "12PM", "1PM", "2PM", "3PM", "4PM", "5PM",
        "6PM", "7PM", "8PM", "9PM", "10PM", "11PM",
        "12AM", "1AM", "2AM", "3AM", "4AM", "5AM",
        "6AM", "7AM", "8AM", "9AM", "10AM", "11AM"
    ]
    
    private let iy_values: [Int] = [145, 187, 219, 230, 217, 188, 141, 102, 69, 60, 72, 103]
    private var currentTimeIndex: Int = 0
    private var currentIYIndex: Int = 6
    
    private func getNextTimestamp() -> String {
        let label = timeLabels[currentTimeIndex]
        currentTimeIndex = (currentTimeIndex + 1) % timeLabels.count
        return label
    }
    
    private var maxValue = 120
    private var minValue = 90
    
    private func generateGlucoseData() -> GlucoseData {
        let timestamp = getNextTimestamp()
        currentIYIndex = (currentIYIndex + 1)
        let level = iy_values[currentIYIndex % iy_values.count]

        var label = ""

        if level == 145 {
            label = "E"
        } else if level == 69 {
            label = "R"
        }

        return GlucoseData(
            timestamp: timestamp,
            level: level,
            verticalMarkerLabel: label
        )
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

