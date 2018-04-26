//
//  LibraryAPI.swift
//  FitnessLife
//
//  Created by Karpenko Elena on 4/22/18.
//  Copyright © 2018 Karpenko Elena. All rights reserved.
//


// Singleton Pattern
import Foundation

final class LibraryAPI {
    
    static let shared = LibraryAPI()
    private let persistencyManager = PersistencyManager()
    private let httpClient = HTTPClient()
    private let isOnline = false
    
    private init() {}
    
    func getCoaches() -> [Coach] {
        return persistencyManager.getCoaches()
    }
    
    func addCoach(_ coach: Coach, at index: Int) {
        persistencyManager.addCoach(coach, at: index)
        if isOnline {
//            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func deleteCoach(at index: Int) {
        persistencyManager.deleteCoach(at: index)
        if isOnline {
//            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
}
