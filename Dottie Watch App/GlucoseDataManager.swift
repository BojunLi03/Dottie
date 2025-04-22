//
//  GlucoseDataManager.swift
//  Dottie
//
//  Created by Bojun Li on 3/31/25.
//


import Foundation
import SwiftUI
import UIKit

struct GlucoseData: Identifiable {
    var timestamp: String
    var level: Int
    var verticalMarkerLabel: String = "" // "" = no line, otherwise draw
    var id = UUID()
}



class GlucoseDataManager: ObservableObject {
    @Published var glucoseData: [GlucoseData] = []//[.init(timestamp: "03/11 11:00", level: 120)]
    @Published var glucoseHistory: [GlucoseData] = []
    
    
    private var timer: Timer? = nil
    private let maxDataPoints = 7
    private let maxHitoryPoints = 24
    
    // Flag to indicate spike
    private var isSpiking = false
    private var isDropped = false

    func startRealTimeUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            let newData = self.generateGlucoseData()
            self.glucoseData.append(newData)
            self.glucoseHistory.append(newData)
            if self.glucoseData.count > self.maxDataPoints {
                self.glucoseData.removeFirst()
            }
            if self.glucoseHistory.count > self.maxHitoryPoints{
                self.glucoseHistory.removeFirst()
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
    
    private let iy_values: [Int] = [120, 162, 193, 205, 196, 160, 117, 79, 45, 40, 49, 80]
    private var currentTimeIndex: Int = 0
    private var currentIYIndex: Int = Int.random(in: 0...10)
    
    private func getNextTimestamp() -> String {
        let label = timeLabels[currentTimeIndex]
        currentTimeIndex = (currentTimeIndex + 1) % timeLabels.count
        return label
    }
    
    private var maxValue = 120
    private var minValue = 90
    
    private func generateGlucoseData() -> GlucoseData {
        let timestamp = getNextTimestamp()
        let prevLevel = iy_values[currentIYIndex % iy_values.count]
        currentIYIndex = (currentIYIndex + 1)
        let level = iy_values[currentIYIndex % iy_values.count] + Int.random(in:-3...3)

        var label = ""

        if level >= 140 && prevLevel < 140 {
            label = "E"
        } else if level <= 75 && prevLevel > 75 {
            label = "R"
        }

        return GlucoseData(
            timestamp: timestamp,
            level: level,
            verticalMarkerLabel: label
        )
    }

    func exportCSVToLocalFile() -> URL? {
        let fileName = "GlucoseData_Export.csv"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        var csvText = "Timestamp,Glucose Level,Marker\n"
        for data in glucoseHistory {
            let line = "\(data.timestamp),\(data.level),\(data.verticalMarkerLabel)\n"
            csvText.append(line)
        }
        
        do {
            try csvText.write(to: path, atomically: true, encoding: .utf8)
            print("CSV saved locally at: \(path)")
            return path
        } catch {
            print("Error writing CSV: \(error)")
            return nil
        }
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

