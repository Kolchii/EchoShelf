//
//  Genre.swift
//  EchoShelf
//
//  Created by Ibrahim Kolchi on 22.03.26.
//
import Foundation

struct Genre: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let colorName: String
}
