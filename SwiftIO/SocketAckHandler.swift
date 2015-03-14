//
//  SocketAckHandler.swift
//  Socket.IO-Swift
//
//  Created by Erik Little on 2/14/15.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

public typealias AckCallback = (NSArray?) -> Void

@objc public class SocketAckHandler {
    let ackNum:Int!
    let event:String!
    var acked = false
    var callback:AckCallback?
    
    init(event:String, ackNum:Int = 0) {
        self.ackNum = ackNum
        self.event = event
    }
    
    public func onAck(timeout:UInt64, withCallback callback:AckCallback) {
        self.callback = callback
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(timeout * NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {[weak self] in
            if self == nil {
                return
            }
            
            if !self!.acked {
                self?.executeAck(["No ACK"])
            }
        }
    }
    
    func executeAck(data:NSArray?) {
        dispatch_async(dispatch_get_main_queue()) {[weak self, cb = self.callback] in
            self?.acked = true
            cb?(data)
            return
        }
    }
}