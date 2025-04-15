//
//  ContentView.swift
//  Dottie Watch App
//
//  Created by Bojun Li on 3/11/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      VStack(spacing: 6) {
        Spacer()
        
        // Dottie logo
        Image("dottie_logo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 80, height: 80)
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
        NavigationLink(destination: GlucoseGraphView(glucoseDataManager: GlucoseDataManager())) {
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
        .buttonStyle(.plain)
        
        // Button to view history
        Button(action: {
          print("View History")
        }) {
          Text("View History")
            .font(.system(size: 13, weight: .medium))
            .frame(height: 35)
            .frame(maxWidth: .infinity)
            .background(Color("gray"))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
        
        Spacer()
      }
      .padding(.horizontal, 12)
      .scrollContentBackground(.hidden)
    }
  }
}

#Preview {
    ContentView()
}
