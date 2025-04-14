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
        VStack(spacing: 8) {
            if isLoading {
                ProgressView("Loading Data...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                HStack {
                    Spacer()
                    if let current = glucoseDataManager.glucoseData.last {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("\(Int(current.level))")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                            Text("mg/DL")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    else{
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("--")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                            Text("mg/DL")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.trailing, 8)
                HStack{
                    VStack{
                        // Spike button
                        Button("Simulate Spike") {
                            glucoseDataManager.simulateSpike()
                        }
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                        
                        // Spike button
                        Button("Simulate Drop") {
                            glucoseDataManager.simulateDrops()
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    glucoseLevelsGraph
                        .frame(height: 180)
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                }
                
            }
        }
        .padding(.top)
        .background(Color.black)
        .onAppear {
            glucoseDataManager.startRealTimeUpdates()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isLoading = false
            }
        }
    }

    
    var glucoseLevelsGraph: some View {
        Chart {
            ForEach(glucoseDataManager.glucoseData) { point in
                // Line mark for glucose level over time
                LineMark(
                    x: .value("Time", point.timestamp),
                    y: .value("Glucose Level", point.level)
                )
                .foregroundStyle(.white)
                
                // Point mark for each glucose data point (dot)
                PointMark(
                    x: .value("Time", point.timestamp),
                    y: .value("Glucose Level", point.level)
                )
                .foregroundStyle(
                    // Conditional color based on glucose level
                    point.level >= 140 ? Color.red : (point.level <= 70 ? Color.blue : Color.white)
                )
                .clipShape(Circle()) // Makes the point a circle
            }
        }
        .chartXAxis(.hidden)
        .chartYScale(domain: 0...200) // Set fixed range for the Y-axis
        //.chartYAxis {
        //    AxisMarks(values: .stride(by: 50)) // Adjust the Y-axis ticks
        //}
    }

}
