//
//  ViewController.swift
//  Speech
//
//  Created by spring on 2018/3/20.
//  Copyright © 2018年 spring. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController,SFSpeechRecognitionTaskDelegate{
    
    let audioEngine:AVAudioEngine! = AVAudioEngine.init()
    let speechRegnizer:SFSpeechRecognizer! = SFSpeechRecognizer.init(locale: Locale.init(identifier: "zh_CN"))
    var speechRequest:SFSpeechAudioBufferRecognitionRequest?
    var speechTask:SFSpeechRecognitionTask?
    
        @IBOutlet weak var txV: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func clickParaseLocal(_ sender: Any) {
        
        let request:SFSpeechURLRecognitionRequest = SFSpeechURLRecognitionRequest.init(url: NSURL.fileURL(withPath:Bundle.main.path(forResource: "1122334455", ofType: "mp3")!))
        speechRegnizer.recognitionTask(with: request, delegate: self)
        self.txV.text = "解析中......"
        
    
    }
    @IBAction func clickRecord(_ sender: Any) {
        if self.speechTask?.state == .running {
            self.recordButton.setTitle("开始说话,识别中", for: .normal)
            self.stopRecord()
        }else{
            self.recordButton.setTitle("停止语音识别", for: .normal)
            self.startRecord()
        }
    }
    func startRecord(){
       // let error:NSError;
        do{
            try self.audioEngine.start()
            
        }catch {}
       
        self.speechRequest = SFSpeechAudioBufferRecognitionRequest.init()

        
        self.speechTask = self.speechRegnizer .recognitionTask(with: self.speechRequest!, resultHandler: { (result, error) in
            if let t_result = result
            {
                self.txV.text = t_result.bestTranscription.formattedString
            }
        })
    }
    
    func stopRecord(){
        self.audioEngine.stop()
        self.speechRequest!.endAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //请求权限
        
        SFSpeechRecognizer.requestAuthorization { (state) in
            if(state != .authorized)
            {
                return;
            }
            self.audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: self.audioEngine.inputNode.outputFormat(forBus: 0), block: { (buffer, when) in
                    self.speechRequest?.append(buffer)
                });
            
            self.audioEngine.prepare()
        }
    }

    func speechRecognitionTaskFinishedReadingAudio(_ task: SFSpeechRecognitionTask) {
    
    print("结束reading")
    }
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {
    print("解析完成")
    }
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        self.txV.text = recognitionResult.bestTranscription.formattedString
        
    }
}

