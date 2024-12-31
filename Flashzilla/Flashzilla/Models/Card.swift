//
//  Card.swift
//  Flashzilla
//
//  Created by Dylan on 27/12/2024.
//
import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String
}

extension Card {
    static let example: Card = Card(prompt: "What is the capital of France?", answer: "Paris")
}
