//
//  CreateSongs.swift
//  
//
//  Created by Ludovic HENRY on 14/07/2023.
//

import Fluent

struct CreateSongs: AsyncMigration {

    func prepare(on database: Database) async throws {
        try await database.schema("songs")
            .id()
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("songs").delete()
    }
}
