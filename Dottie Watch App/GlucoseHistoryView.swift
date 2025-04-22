//
//  GlucoseHistoryView.swift
//  Dottie
//
//  Created by Bojun Li on 4/22/25.
//


import SwiftUI
struct GlucoseHistoryView: View {
    @ObservedObject var glucoseDataManager: GlucoseDataManager
    
    var body: some View {
        NavigationView {
            VStack {
                
                List(glucoseDataManager.glucoseHistory.reversed()) { data in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(data.timestamp)
                                .font(.headline)
                            Text("Glucose Level: \(data.level)")
                                .font(.subheadline)
                                .foregroundColor(data.level >= 180 ? Color.red :
                                                    (data.level <= 80 ? Color.blue : Color.white))
                        }
                        Spacer()
                        if !data.verticalMarkerLabel.isEmpty {
                            Text(data.verticalMarkerLabel)
                                .font(.body)
                                .foregroundColor(data.verticalMarkerLabel == "E" ? .red : .green)
                                .padding(5)
                                .background(data.verticalMarkerLabel == "E" ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                }
                //.navigationTitle("Glucose History")
            }
        }.onAppear {
            print("GlucoseHistoryView appeared")
            print("Current glucoseHistory: \(glucoseDataManager.glucoseHistory)")
        }
    }
    
}
