//
//  RecordingAnalyticsDrawerView.swift
//  visualizer
//
//  Created by Yeung on 13/7/2022.
//

import Foundation
import SwiftUI

struct RecordingAnalyticsDrawerView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var recordingAnalyticsDrawerVM: RecordingAnalyticsDrawerViewModel
    @EnvironmentObject var audioVM: AudioViewModel
    @Binding var isShowing: Bool
    
    @State private var analyticsMode: RecordingAnalyticsDrawer.AnalyticsTypes = .melody
    @State private var noteSelectedToAnalyze: Int = 0
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                // Presentation Sheet Header
                Group {
                    Spacer()
                        .frame(height: 8)
                    
                    HStack(alignment: .center) {
                        Spacer()
                        
                        Text("Analytics")
                            .font(.heading.small)
                        
                        Spacer()
                            .overlay(
                                DismissButton(action: { presentationMode.wrappedValue.dismiss() }),
                                alignment: .trailing
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Spacer()
                    .frame(height: 32)
                
                // Segmented Control
                HStack(){
                    Spacer()
                    Picker("Analysis Mode", selection: $analyticsMode) {
                        Text(RecordingAnalyticsDrawer.AnalyticsTypes.melody.label)
                            .tag(RecordingAnalyticsDrawer.AnalyticsTypes.melody)
                        Text(RecordingAnalyticsDrawer.AnalyticsTypes.notes.label)
                            .tag(RecordingAnalyticsDrawer.AnalyticsTypes.notes)
                    }
                    .pickerStyle(.segmented)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .padding(EdgeInsets(top: 16, leading: 24, bottom: 0, trailing: 24))
            .foregroundColor(.neutral.onBackground)
            
            Spacer()
                .frame(height: 32)
            
            VStack {
                RecordingAmplitudes(amplitudes: audioVM.audio.recording.recordedAmplitude,
                                    noteSelectedToAnalyze: $noteSelectedToAnalyze,
                                    splittedNoteIndices: audioVM.audio.recording.splittedNoteIndices)
            }
            .frame(maxWidth: .infinity, maxHeight: 150)
            .background(Color("surfaceVariant"))
            
            Spacer()
                .frame(height: 32)
            
            VStack(alignment: .leading) {
                switch analyticsMode {
                case .melody:
                    VStack {
                        AnalyticsChart(title: "Dynamic",
                                       descriptiveText: "How consistent your dynamic is",
                                       data: audioVM.audio.recording.recordedAmplitude)
                        
                        Spacer()
                            .frame(height: 32)
                        
                        AnalyticsChart(title: "Accuracy",
                                       descriptiveText: "What percent are you in tune",
                                       data: audioVM.audio.recording.recordedAmplitude)
                    }
                case .notes:
                    VStack {
                        AnalyticsChart(title: "Dynamic",
                                       descriptiveText: "Attack, Sustain, Release, Decay",
                                       data: audioVM.audio.recording.splittedRecording.count > 0 ? audioVM.audio.recording.splittedRecording[noteSelectedToAnalyze] : [])
                        
                        Spacer()
                            .frame(height: 32)
                        
                        AnalyticsChart(title: "Accuracy",
                                       descriptiveText: "How your pitch change within a note",
                                       data:  audioVM.audio.recording.splittedRecording.count > 0 ? audioVM.audio.recording.splittedRecording[noteSelectedToAnalyze] : [])
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
            .foregroundColor(.neutral.onBackground)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct RecordingAnalyticsDrawer_Previews: PreviewProvider {
    static var previews: some View {
        RecordingAnalyticsDrawerView(isShowing: .constant(true)
        )
        .environmentObject(RecordingAnalyticsDrawerViewModel())
        .environmentObject(AudioViewModel())
    }
}
