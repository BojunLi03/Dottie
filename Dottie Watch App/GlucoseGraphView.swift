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
                }
                .padding(.trailing, 8)
                HStack{
                    glucoseLevelsGraph
                        .frame(height: 180)
                        .padding(.horizontal)

                    // Spike button
                    Button("Simulate Spike") {
                        glucoseDataManager.simulateSpike()
                    }
                    .padding()
                    .background(Color.red.opacity(0.7))
                    .cornerRadius(8)
                    .foregroundColor(.white)
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
        LineMark(
          x: .value("Time", point.timestamp),
          y: .value("Glucose Level", point.level)
        )
        .foregroundStyle(.white)
      }
    }
    .chartXAxis(.hidden)
    .chartYScale(domain: 60...230)
    .chartYAxis {
        AxisMarks(values: .stride(by: 50))
    }
  }
}
