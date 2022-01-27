//
//  MonitorListViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 19/1/22.
//

import UIKit
import Foundation
import SwiftUI
import RealmSwift

struct MonitorContentView: View {
    var body: some View {
        MonitorListView()
            .environment(\.realmConfiguration, config)
            
    }
}

struct MonitorListView: View {
    
    @ObservedResults(MonitorItem.self) var items
    
    var body: some View {
        NavigationView {
            VStack {
            if items.count > 0 {
                List {
                    ForEach(items.reversed()) { item in
                        MonitorItemView(item: item)
                    }
                }
            } else {
                Text("There's nothing in the monitor log")
            }
            }
            .navigationTitle("Monitor")
            .preferredColorScheme(.dark)
        }
    }
}

struct MonitorItemView: View {
    
    @ObservedRealmObject var item: MonitorItem
    @State var isLoading: Bool = false
    
    var textColor: Color {
        switch item.list {
        case 0:
            return .green
        case 1:
            return .red
        default:
            return .white
        }
    }
    
    var body: some View {
        HStack{
            Text("\(item.url)")
                .foregroundColor(textColor)
            Spacer()
            Text("\(item.timestamp.getFormattedDate(format: "HH:mm"))")
        }
        .padding()
        .fullScreenCover(isPresented: $isLoading, content: ProgressView.init)
        .contextMenu {
            switch item.list{
            case 0:
                Button {
                    swapList(url: item.url, toList: .block)
                } label: {
                    Label("Move to Block List", systemImage: "xmark.shield")
                }
            case 1:
                Button {
                    isLoading.toggle()
                    swapList(url: item.url, toList: .allow)
                    TunnelController.shared.restartTunnel()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isLoading.toggle()
                    }
                } label: {
                    Label("Move to Allow List", systemImage: "checkmark.shield")
                }
            default:
                Button {
                    addItemToList(url: item.url, list: .block)
                    TunnelController.shared.restartTunnel()
                } label: {
                    Label("Add to Block List", systemImage: "xmark.shield")
                }
                Button {
                    addItemToList(url: item.url, list: .allow)
                    TunnelController.shared.restartTunnel()
                } label: {
                    Label("Add to Allow List", systemImage: "checkmark.shield")
                }
            }
        }
    }
}

class MonitorListViewController: UIHostingController<MonitorContentView> {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: MonitorContentView())
    }

}
