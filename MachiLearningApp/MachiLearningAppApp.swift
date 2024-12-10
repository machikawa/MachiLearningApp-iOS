//
//  MachiLearningAppApp.swift
//  MachiLearningApp
//
//  Created by たうんりばーVR on 2024/10/22.
//

import SwiftUI

@main
struct MachiLearningAppApp: App {
    
    // AppDelegateをSwiftUIに統合
     @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
