#!/usr/bin/swift

import Foundation

class City: Codable {

	public var name: String
	public var state: String
	public var ddd: String

	public init(name: String, state: String, ddd: String) {
		self.name = name
		self.state = state
		self.ddd = ddd
	}

	func toDictionary() -> [String: Any] {
		return ["name": name, "state": state, "ddd": ddd]
	}
}

class DDDListProcessor {
	func loadFile() -> String? {
		let filePath = "DDDCityList.txt"

		let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
		let path = URL(fileURLWithPath: filePath, relativeTo: currentDirectoryURL)

		do {
			return try String(contentsOf: path, encoding: String.Encoding.utf8)
		} catch {
			print(error)
		}

		return nil
	}

	func process(result: String?) -> [City] {
		guard let content = result else { return [City]() }

		var ddd = ""
		var cities = [City]()
		for l in content.split(separator: "\n") {
			let line = String(l)
			if String(line).range(of: "DDD ") != nil {
				ddd = line.replacingOccurrences(of: "DDD ", with: "")
			} else {
				let cityState = line.split(separator: "\t")
				cities.append(City(name: String(cityState[0]).capitalized, state: String(cityState[1]), ddd: ddd))
			}
		}

		return cities
	}

	func toFile(cities: [City]) {
		let filePath = "DDDCityList.json"
		let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
		let path = URL(fileURLWithPath: filePath, relativeTo: currentDirectoryURL)

		do {
			let data = try? JSONEncoder().encode(cities)
			try data!.write(to: path, options: [])
		} catch {
			print(error)
		}
	}

	func doIt() {
		toFile(cities: process(result: loadFile()))
	}
}

DDDListProcessor().doIt()
