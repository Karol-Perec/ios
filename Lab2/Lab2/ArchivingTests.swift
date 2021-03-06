//
//  ArchivingTests.swift
//  Lab2
//
//  Created by Karol Perec on 14/01/2020.
//  Copyright © 2020 Karol Perec. All rights reserved.
//

import Foundation

func generateDataArchiving() {
    var sensors = [Sensor]()
    var readings = [Reading]()
    
    do {
        try FileManager.default.removeItem(atPath: Sensor.ArchiveURL.path)
        try FileManager.default.removeItem(atPath: Reading.ArchiveURL.path)
    } catch {
        print("Could not delete file: \(error)")
    }
    
    for i in 1...20 {
        let sensor = Sensor(name: String(format: "S%02d", i), desc: "Sensor number \(i)")
        sensors.append(sensor)
    }
    
    let isSuccessfulSensorsSave = NSKeyedArchiver.archiveRootObject(sensors, toFile: Sensor.ArchiveURL.path)
    if isSuccessfulSensorsSave {
        print("Sensors successfully saved.")
    } else {
        print("Failed to save sensors...")
    }
    
    for _ in 1...ViewController.numberOfReadings {
        let reading = Reading(sensors: sensors)
        readings.append(reading)
    }
    
    let isSuccessfulReadingsSave = NSKeyedArchiver.archiveRootObject(readings, toFile: Reading.ArchiveURL.path)
    if isSuccessfulReadingsSave {
        print("Readings successfully saved.")
    } else {
        print("Failed to save sensors...")
    }
}

func timestampQueryArchiving() {
    guard let readings = NSKeyedUnarchiver.unarchiveObject(withFile: Reading.ArchiveURL.path) as? [Reading] else {
        fatalError("Cannot read data")
    }
    let max = readings.max(by: { a, b in a.timestamp < b.timestamp })
    let min = readings.max(by: { a, b in a.timestamp > b.timestamp })
    print("Maximum timestamp: \(max!.timestamp), minimum timestamp: \(min!.timestamp)")
}

func averageReadingQueryArchiving() {
    guard let readings = NSKeyedUnarchiver.unarchiveObject(withFile: Reading.ArchiveURL.path) as? [Reading] else {
        fatalError("Cannot read data")
    }
    
    let averageReading = readings.reduce(0, {$0 + $1.value})/Float(ViewController.numberOfReadings)
    print("Average reading: \(averageReading)")
}

func readingPerSensorQueryArchiving() {
    guard let readings = NSKeyedUnarchiver.unarchiveObject(withFile: Reading.ArchiveURL.path) as? [Reading] else {
        fatalError("Cannot read data")
    }
    
    for i in 1...20 {
        let readingsPerSensor = readings.filter{ $0.sensor.name == String(format: "S%02d", i) }
        let numberOfReadingsPerSensor = readingsPerSensor.count
        if numberOfReadingsPerSensor != 0 {
            let averageReadingPerSensor = readingsPerSensor.reduce(0, {$0 + $1.value})/Float(numberOfReadingsPerSensor)
            print("Sensor number \(i): number of readings is \(numberOfReadingsPerSensor), average: \(averageReadingPerSensor)")
        }
    }
}
