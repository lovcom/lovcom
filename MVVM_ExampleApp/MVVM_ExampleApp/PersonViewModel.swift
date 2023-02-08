//
//  PersonViewModel.swift
//  MVVM_ExampleApp
//
//  Created by Dan Lovell on 1/23/23.
//

import SwiftUI

class PersonViewModel: ObservableObject {
    @Published var people: [Person] = []
    
    init() {
     addPeople()
    }
    
    func addPeople() {
       people = peopleData
    }
    
    func shuffleOrder() {
        people.shuffle()
    }
    
    func reverseOrder() {
        people.reversed()
    }
    
    func removeLastPerson() {
        people.removeLast()
    }
    
    func removeFirstPerson() {
        people.removeFirst()
    }
    
}

let peopleData = [
    Person(name: "Dan Lovell", email: "lovcom@gmail.com", phoneNumber: "714-269-5515"),
    Person(name: "Julie Lovell", email: "Jewel44Love@gmail.com", phoneNumber: "714-369-5515"),
    Person(name: "Jennifer Campbell", email: "Jenny@gmail.com", phoneNumber: "714-469-5515"),
    Person(name: "Delaney Barney", email: "Delaney@gmail.com", phoneNumber: "714-569-5515"),
    Person(name: "Garrett Barney", email: "Garrett@gmail.com", phoneNumber: "714-669-5515"),
    Person(name: "Bobby Campbell", email: "Bobby@gmail.com", phoneNumber: "714-769-5515"),
    Person(name: "Easton Barney", email: "Easton@gmail.com", phoneNumber: "714-869-5515"),
    Person(name: "Everly Barney", email: "Everly@gmail.com", phoneNumber: "714-969-5515"),
    Person(name: "Anna Head", email: "Anna@gmail.com", phoneNumber: "714-345-5515")
 ]
