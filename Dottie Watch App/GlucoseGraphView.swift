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
                
                glucoseLevelsGraph
                    .frame(height: 180)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                //}
                
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
        ZStack{
            
            Chart {
                ForEach(glucoseDataManager.glucoseData) { point in
                    LineMark(
                        x: .value("Time", point.timestamp),
                        y: .value("Glucose Level", point.level)
                    )
                    .foregroundStyle(.white)

                    PointMark(
                        x: .value("Time", point.timestamp),
                        y: .value("Glucose Level", point.level)
                    )
                    .foregroundStyle(
                        point.level >= 180 ? Color.red :
                        (point.level <= 80 ? Color.blue : Color.white)
                    )
                    .clipShape(Circle())

                    if !point.verticalMarkerLabel.isEmpty {
                        RuleMark(x: .value("Time", point.timestamp))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                            .foregroundStyle(.yellow.opacity(0.8))
                            .annotation(position: .top, alignment: .center) {
                                Text(point.verticalMarkerLabel)
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            }
                    }
                }
            }
            .chartXAxis(.hidden)
            .chartYScale(domain: 0...225)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        print("Export button pressed")
                        _ = glucoseDataManager.exportCSVToLocalFile()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.yellow)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    .padding(.trailing, 8)
                    .padding(.bottom, 8)
                }
            }
            .allowsHitTesting(true)

        }
        
        
    }


}
