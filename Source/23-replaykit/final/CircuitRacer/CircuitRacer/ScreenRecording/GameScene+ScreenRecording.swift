/*
 * Copyright (c) 2016-2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import UIKit
import ReplayKit

extension GameScene: AutoRecordProtocol, ScreenRecordingAvailable {
  func showScreenRecordingAlert(message: String) {
    isPaused = true
    
    let alertController = UIAlertController(title: nil,
                                            message: message, preferredStyle: .alert)
    
    let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
      self.isPaused = false
    }
    alertController.addAction(alertAction)
    
    DispatchQueue.main.async {
      self.view?.window?.rootViewController?.present(alertController, animated: false, completion: nil)
    }
  }
  
  func startScreenRecording() {
    // 1
    guard screenRecordingToggleEnabled && screenRecordingAvailable else { return }
    
    // 2
    let sharedRecorder = RPScreenRecorder.shared()
    
    sharedRecorder.delegate = self
    
    // 3
    sharedRecorder.startRecording { error in
      if let error = error {
        self.showScreenRecordingAlert(message: error.localizedDescription)
      }
    }
  }
  
  func stopScreenRecording(with completionHandler: @escaping ((Void) -> Void)) {
    // 1
    let sharedRecorder = RPScreenRecorder.shared()
    
    // 2
    sharedRecorder.stopRecording { (previewViewController, error) in
      if let error = error {
        // 3
        self.showScreenRecordingAlert(message: error.localizedDescription)
        return
      }
      
      if let previewViewController = previewViewController {
        // 4
        previewViewController.previewControllerDelegate = self
        self.previewViewController = previewViewController
      }
      // 5
      completionHandler()
    }
  }
  
  func discardRecording() {
    RPScreenRecorder.shared().discardRecording {
      self.previewViewController = nil
    }
  }
  
  func stopAndDiscardRecording() {
    let sharedRecorder = RPScreenRecorder.shared()
    if sharedRecorder.isRecording {
      sharedRecorder.stopRecording { (previewViewController, error) in
        self.discardRecording()
      }
    } else {
      discardRecording()
    }
  }
  
  func displayRecordedContent() {
    guard let previewViewController = previewViewController else { fatalError("The user requested playback, but a valid preview controller does not exist.") }
    guard let rootViewController = view?.window?.rootViewController else { fatalError("The scene must be contained in a window with a root view controller.") }
    
    previewViewController.modalPresentationStyle = .fullScreen
    
    SKTAudio.sharedInstance().pauseBackgroundMusic()
    rootViewController.present(previewViewController,
                                             animated: true, completion:nil)
  }
}

extension GameScene: RPPreviewViewControllerDelegate {
  func previewController(_ previewController: RPPreviewViewController,
                         didFinishWithActivityTypes activityTypes: Set<String>) {
    previewViewController?.dismiss(animated: true, completion: nil)
    SKTAudio.sharedInstance().resumeBackgroundMusic()
  }
}

extension GameScene: RPScreenRecorderDelegate {
  func screenRecorder(_ screenRecorder: RPScreenRecorder,
                      didStopRecordingWithError error: Error,
                      previewViewController: RPPreviewViewController?) {
    self.previewViewController = previewViewController
  }
}
