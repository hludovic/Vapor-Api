//
//  SongController.swift
//  
//
//  Created by Ludovic HENRY on 14/07/2023.
//

import Fluent
import Vapor

struct SongController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        songs.delete(":songID", use: delete)
    }

    // GET request /songs route
    func index(req: Request) async throws -> [Song] {
        try await Song.query(on: req.db).all()
    }

    // POST request /songs route
    func create(req: Request) async throws -> HTTPStatus {
        let song = try req.content.decode(Song.self)
        try await song.save(on: req.db)
        return .ok
    }

    // PUT request /songs route
    func update(req: Request) async throws -> HTTPStatus {
        let song = try req.content.decode(Song.self)
        guard let songFromDB = try await Song.find(song.id, on: req.db) else {
            throw Abort(.notFound)
        }
        songFromDB.title = song.title
        try await songFromDB.update(on: req.db)
        return .ok
    }

    // DELETE request /songs/id route
    func delete(req: Request) async throws -> HTTPStatus {
        guard let songID = req.parameters.get("songID") else {
            throw Abort(.notFound)
        }
        guard let songFromDB = try await Song.find(UUID(uuidString: songID), on: req.db) else {
            throw Abort(.notFound)
        }
        try await songFromDB.delete(on: req.db)
        return .ok
    }

}
