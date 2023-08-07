//
//  File.swift
//  
//
//  Created by Piotr Żmudziński on 07/08/2023.
//

import Foundation

// https://ogp.me/#types
public enum OpenGraphTag: String, CaseIterable {
    // Basic Metadata
    case title
    case type
    case image
    case url
    
    // Optional Metadata
    case audio
    case description
    case determiner
    case locale
    case localeAlternate = "locale:alternate"
    case siteName = "site_name"
    case video
    
    // Structured Properties
    case imageUrl        = "image:url"
    case imageSecure_url = "image:secure_url"
    case imageType       = "image:type"
    case imageWidth      = "image:width"
    case imageHeight     = "image:height"
    
    // Music
    case musicDuration    = "music:duration"
    case musicAlbum       = "music:album"
    case musicAlbumDisc   = "music:album:disc"
    case musicAlbumMusic  = "music:album:track"
    case musicMusician    = "music:musician"
    case musicSong        = "music:song"
    case musicSongDisc    = "music:song:disc"
    case musicSongTrack   = "music:song:track"
    case musicReleaseDate = "music:release_date"
    case musicCreator     = "music:creator"

    // Video
    case videoActor       = "video:actor"
    case videoActorRole   = "video:actor:role"
    case videoDirector    = "video:director"
    case videoWriter      = "video:writer"
    case videoDuration    = "video:duration"
    case videoReleaseDate = "video:releaseDate"
    case videoTag         = "video:tag"
    case videoSeries      = "video:series"

    // No Vertical
    case articlePublishedTime  = "article:published_time"
    case articleModifiedTime   = "article:modified_time"
    case articleExpirationTime = "article:expiration_time"
    case articleAuthor         = "article:author"
    case articleSection        = "article:section"
    case articleTag            = "article:tag"

    case bookAuthor      = "book:author"
    case bookIsbn        = "book:isbn"
    case bookReleaseDate = "book:release_date"
    case bookTag         = "book:tag"

    case profileFirstName = "profile:first_name"
    case profileLastName  = "profile:last_name"
    case profileUsername  = "profile:username"
    case profileGender    = "profile:gender"
}
