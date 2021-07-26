//
//  TulaEntryView.swift
//  widgetExtension
//
//  Created by Arjun Singh on 18/2/21.
//

import SwiftUI

struct TulaEntryView: View {
    
    let entry: StatsEntry
    
    var body: some View {
        VStack (alignment: .center, content: {
            Text("\(entry.blockCount.roundedWithAbbreviations)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 2)
            Text("BLOCKED")
                .font(.footnote)
                .fontWeight(.regular)
                .foregroundColor(Color(UIColor.systemGray5))
            Text("SINCE STARTUP")
                .font(.footnote)
                .fontWeight(.regular)
                .foregroundColor(Color(UIColor.systemGray5))
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(UIColor(named: "AccentColor")!))
        .cornerRadius(15)
    }
    }


extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(self)"
        }
    }
}
