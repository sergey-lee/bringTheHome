//
//  ApiResult.swift
//  mellowing-factory
//
//  Created by Florian Topf on 28.01.22.
//

enum ApiResult<T> {
    case success(T), failure(Error)
}

enum ApiError: Error {
    case invalidUrl, invalidJSON, httpError, notFound, generalError
}
