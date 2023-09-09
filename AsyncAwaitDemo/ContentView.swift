//
//  ContentView.swift
//  AsyncAwaitDemo
//
//  Created by Thongchai Subsaidee on 9/9/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var data: String = "Loading..."
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var count: Int = 0
    
    var body: some View {
        VStack {
            
            Text("Count: \(count)")
            
            Text(data)
                .padding()
            
            Button("Fetch data") {
                fetchData()
            }
            .padding()
            
            Button("Start") {
                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                count = 0
                data = "Loadiing..."
            }
            
            Button("Stop") {
                timer.upstream.connect().cancel()
                data = "Stop"
            }
            .padding()
        }
        .onReceive(timer) { _ in
            count = count + 1
            if count > 10 {
                data = "end when more then 10"
            }
        }
    }
    
    func fetchData() {
        print(111)
        Task {
            do {
                let result = try await fetchDataFromServer()
                data = result
            }catch {
                data = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    
    func fetchDataFromServer() async throws -> String {
        print(222)
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        return "Data from server"
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
