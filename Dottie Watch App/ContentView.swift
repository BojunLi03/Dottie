//
//  ContentView.swift
//  Dottie Watch App
//
//  Created by Bojun Li on 3/11/25.
//

import SwiftUI

struct ContentView: View {
    // Create a shared instance of GlucoseDataManager
    @StateObject var glucoseDataManager = GlucoseDataManager()
    
    var body: some View {
        // Wrap the main VStack in a NavigationView
        NavigationView {
            VStack(spacing: 6) {
                Spacer()
                
                // Dottie logo
                Image("dottie_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
                    .padding(.top, 4)
                
                // Welcome text
                Text("Welcome to Dottie!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 2)
                
                // NavigationLink to GlucoseGraphView
                NavigationLink(destination: GlucoseGraphView(glucoseDataManager: glucoseDataManager)) {
                    Text("View Glucose Levels")
                        .font(.system(size: 13, weight: .medium))
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                        .frame(height: 35)
                        .frame(maxWidth: .infinity)
                        .background(Color("purple"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // NavigationLink to GlucoseHistoryView
                NavigationLink(destination: GlucoseHistoryView(glucoseDataManager: glucoseDataManager)) {
                    Text("View History")
                        .font(.system(size: 13, weight: .medium))
                        .frame(height: 35)
                        .frame(maxWidth: .infinity)
                        .background(Color("gray"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding(.horizontal, 12)
        }
    }
}

#Preview {
    ContentView()
}

