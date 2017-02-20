//
//  Track.swift
//  HalfTunes
//
//  Created by Ken Toh on 13/7/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//

class Track {
  var name: String?
  var type: String?
  var previewUrl: String?
  
  init(name: String?, type: String?, previewUrl: String?) {
    self.name = name
    self.type = type
    self.previewUrl = previewUrl
  }
}
