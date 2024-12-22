//
//  FileHelpers.swift
//  mellowing-factory
//
//  Created by Florian Topf on 31.07.21.
//

import Foundation

/// this helper is only used to list files in the testing app
func getCreationDateFromFileAttribute(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}

func getFileURL(fileName: String) -> URL {
    let documentURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    return documentURL.appendingPathComponent(fileName, isDirectory: false)
}

func deleteFiles(urlsToDelete: [URL]) {
    for url in urlsToDelete {
        print("Deleting \(url.lastPathComponent).")
        do {
           try FileManager.default.removeItem(at: url)
        } catch {
            print("Error deleting file: \(error).")
        }
    }
}

func getDocumentDirectory() -> [URL] {
    let fileManager = FileManager.default
    let documentDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let directoryContents = try! fileManager.contentsOfDirectory(
        at: documentDirectory,
        includingPropertiesForKeys: nil)
    
    return directoryContents
}

func clearDocumentDirectory() {
    deleteFiles(urlsToDelete: getDocumentDirectory())
}


func getRealmDocs() -> [URL] {
    let fileManager = FileManager.default
    let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let directoryContents = try! fileManager.contentsOfDirectory(
        at: documentDirectory,
        includingPropertiesForKeys: nil)
    
    return directoryContents
}
