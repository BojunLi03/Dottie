//
//  GlucoseGraphView.swift
//  Dottie
//
//  Created by Bojun Li on 3/25/25.
//


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
