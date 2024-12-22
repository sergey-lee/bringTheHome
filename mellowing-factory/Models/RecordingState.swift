//
//  RecordingState.swift
//  mellowing-factory
//
//  Created by Florian Topf on 16.08.21.
//

enum RecordingError {
    case generalError
}

enum RecordingState: Hashable {
    case recording, stopped, suspended, error(RecordingError)
}
