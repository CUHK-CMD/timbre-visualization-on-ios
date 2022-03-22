//
//  Harmonics.swift
//  visualizer
//
//  Created by Mark Cheng on 8/2/2022.
//

import SwiftUI

struct Harmonics: View {
    
    var harmonics: [Double]
    var isReference: Bool
    
    func getWidth(_ width: CGFloat) -> CGFloat {
        let divider = harmonics.count + harmonics.count / 2
        return width / CGFloat(divider)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    ForEach((1...harmonics.count), id: \.self) { i in
                        Spacer()
                        
                        if (!isReference) {
                            VStack {
                                VBar(val: harmonics[i-1]*7.0,
                                     width: Int(getWidth(geometry.size.width)),
                                     color: Color.accent.highlight,
                                     showValue: false
                                )
                            }
                        } else {
                            VStack {
                                ReferenceBar(val: harmonics[i-1]*7.0,
                                     width: Int(getWidth(geometry.size.width)),
                                     color: Color(red: 0, green: 1, blue: 0.4784313725, opacity: 1),
                                     showValue: false
                                )
                            }
                        }
                        
                        if (i == harmonics.count) {
                            Spacer()
                        }
                    }
                }
                
                Rectangle()
                    .fill(Color.neutral.axis)
                    .frame(width: .infinity, height: 2)
                
                HStack {
                    ForEach((1...harmonics.count), id: \.self) { i in
                        Spacer()
                        VStack {
                            Text("\(i)")
                                .frame(width: getWidth(geometry.size.width))
                                .foregroundColor(.neutral.onAxis)
                        }
                        if (i == harmonics.count) {
                            Spacer()
                        }
                    }
                }
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height,
                   alignment: .bottom)
        }
    }
}

struct FixedSpacer: View {
    var body: some View {
        Spacer()
            .frame(minWidth: 4, idealWidth: 7, maxWidth: 10)
            .fixedSize()
    }
}

struct Harmonics_Previews: PreviewProvider {
    static var previews: some View {
        Harmonics(harmonics: Array(repeating: 0.5, count: 12),
                  isReference: false
        )
    }
}
