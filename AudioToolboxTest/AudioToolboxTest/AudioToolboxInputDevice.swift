//
//  AudioToolboxInputDevice.swift
//  AudioToolboxTest
//
//  Created by Gieta Laksmana on 11/7/23.
//

import Foundation
import AudioToolbox
import AppKit

public enum AudioInputDeviceError: Error {
    case allocateBufferFailed
    case enqueueBufferFailed
    case openAudioQueueFailed
    case startingAudioQueueFailed
    case unsupportedAudioFormat
}

public final class AudioToolboxInputDevice {

    // MARK: Private Properties

    fileprivate let queue: DispatchQueue = DispatchQueue(label: "AudioToolboxInputDevice.\(UUID().uuidString)")
    fileprivate let numBackingAudioBuffers = 4
    fileprivate let minSamplesPerSecond: UInt = 8000

    fileprivate var audioQueue: AudioQueueRef? = nil
    fileprivate var samplesBuffers = [AudioQueueBufferRef]()
    fileprivate var expectedFramesPerPacket: UInt = 0
    fileprivate var counter = 0
    // MARK: Public Methods

    public init() {
    }
    
    deinit {
        print("987987 audio queue deinit")
    }

  
    public func open() throws {
        print("Opening audio input device")

        var audioStreamBasicDescription = AudioStreamBasicDescription(
            mSampleRate: Double(44100),
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked,
            mBytesPerPacket: 4,
            mFramesPerPacket: 1,
            mBytesPerFrame: 4,
            mChannelsPerFrame: 2,
            mBitsPerChannel: 16,
            mReserved: 0)
        
        let callback: AudioQueueInputCallbackBlock = { [weak self] (audioQueue, buffer, _, _, _) in
            guard let audioQueue = self?.audioQueue else {
                print("cannot process audio input data, audioQueue is nil")
                return
            }
            self?.counter += 1
            let data = Data(bytes: UnsafePointer<UInt8>(OpaquePointer(buffer.pointee.mAudioData)), count: Int(buffer.pointee.mAudioDataByteSize))
            
            let retval = AudioQueueEnqueueBuffer(audioQueue, buffer, 0, nil)
            print("[\(self?.counter)] audio input data \(data.count) bytes, returned \(retval)")
        }

        var status: OSStatus = 0
        
        status = AudioQueueNewInputWithDispatchQueue(&self.audioQueue, &audioStreamBasicDescription, 0, DispatchQueue.global(qos: .userInteractive), callback)
        if status != 0 {
            throw AudioInputDeviceError.openAudioQueueFailed
        }

        try self.allocateBuffers()

        status = AudioQueueStart(self.audioQueue!, nil)
        if status != 0 {
            throw AudioInputDeviceError.startingAudioQueueFailed
        }
    }

    public func close() {
        print("Closing audio input device")

        guard self.audioQueue != nil else {
            return
        }

        self.freeBuffers()

        let myAudioQueue = self.audioQueue
        self.audioQueue = nil

        //Wait for the audio queue to stop before disposing it.
        AudioQueueStop(myAudioQueue!, true)
        AudioQueueDispose(myAudioQueue!, false)
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
//            
//        }
        
    }

    // MARK: Private Methods

    fileprivate func calculateBufferSize() throws -> UInt32 {
        let expectedFramesPerPacket = 441
        let channelCount = 2
        return UInt32(2 * expectedFramesPerPacket * channelCount)
    }

    fileprivate func allocateBuffers() throws {
        let bufferSize = try calculateBufferSize()
        var status: OSStatus = 0

        freeBuffers()

        for i in 0..<numBackingAudioBuffers {
            var bufferRef: AudioQueueBufferRef?
            
            status = AudioQueueAllocateBuffer(audioQueue!, bufferSize, &bufferRef)
            if status != 0 {
                throw AudioInputDeviceError.allocateBufferFailed
            }
            samplesBuffers.append(bufferRef!)

            status = AudioQueueEnqueueBuffer(audioQueue!, samplesBuffers[i], 0, nil)
            if status != 0 {
                throw AudioInputDeviceError.enqueueBufferFailed
            }
        }
    }
    
    fileprivate func freeBuffers() {
        for buffer in samplesBuffers {
            AudioQueueFreeBuffer(audioQueue!, buffer)
        }
        samplesBuffers.removeAll()
    }
}
