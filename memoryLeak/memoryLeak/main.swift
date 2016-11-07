//
//  main.swift
//  memoryLeak
//
//  Created by Gieta Laksmana on 9/13/16.
//  Copyright © 2016 gietal. All rights reserved.
//

import Foundation

open class RDCAudioInputAdaptor {
    
    fileprivate unowned let session: RDCSessionConnection
    
    init(ses: RDCSessionConnection) {
        Swift.print("init RDCAudioInputAdaptor")
        session = ses
    }
    
    deinit {
        Swift.print("deinit RDCAudioInputAdaptor")
    }
}

open class RDCSessionConnection {
    
    open var audio: RDCAudioInputAdaptor?
    
    open func setAudio() {
        Swift.print("RDCSessionConnection set audio")
        audio = RDCAudioInputAdaptor(ses: self)
    }
    
    public init() {
        Swift.print("init RDCSessionConnection")
    }
    
    deinit {
        Swift.print("deinit RDCSessionConnection")
    }
    
}
open class Session {
    
    open var connection: RDCSessionConnection
    
    public init(conn: RDCSessionConnection) {
        Swift.print("init Session")
        connection = conn
    }
    
    deinit {
        Swift.print("deinit Session")
    }
}

func test() {
    
    let rdcConn = RDCSessionConnection()
    let session = Session(conn: rdcConn)
    rdcConn.setAudio()
    Swift.print("audio: " + rdcConn.audio.debugDescription)
    
}

// main //
print("---------- test begin ----------")
test()
print("---------- test end ----------")
