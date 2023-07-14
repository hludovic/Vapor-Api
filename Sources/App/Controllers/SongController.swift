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

    }

    // /songs route
    func index(req: Request) async throws -> [Song] {
        return try await Song.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return song.save(on: req.db).transform(to: .ok)
    }

}
