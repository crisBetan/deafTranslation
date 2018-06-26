//  ViewController.swift
//  pruebasAudioTexto
//
//  Created by Jerry Servicio Social on 11/04/18.
//  Copyright © 2018 Jerry Servicio Social. All rights reserved.

import UIKit
import Speech
import AVKit


class ViewController: UIViewController, LanguagesViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    let audioEngine = AVAudioEngine( )
    var speechRecognizer = SFSpeechRecognizer( )
    let request = SFSpeechAudioBufferRecognitionRequest( )
    var recognitionTask: SFSpeechRecognitionTask?
    
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lanButton = UIBarButtonItem(title: "Languages", style: .plain, target: self, action: #selector(selectLanguages))
        self.navigationItem.rightBarButtonItem = lanButton
    }
    
    @objc func selectLanguages( ){
        guard let lanView = storyboard?.instantiateViewController(withIdentifier: "lan") as? LanguagesViewController else {return}
        lanView.delegate = self //tiene sus funciones, manda un string... de los lenguajes. Una tortillería, recipiente del delegate de hasta arriba
        let nv = UINavigationController(rootViewController: lanView)
        self.present(nv, animated: true, completion: nil)
    }
    
    func recordAndRecognizeSpeech(){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, audioTime) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch{
            print("Falló al recibir audio: \(error.localizedDescription)")
        }
        guard let speechRecognizer = speechRecognizer else {return}
        if speechRecognizer.isAvailable{
            recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { (result, error) in
                if let result = result{
                    let bestString = result.bestTranscription.formattedString
                    self.textView.text = bestString
                }
            })
        }
    }

    @IBAction func startOperation(_ sender: UIButton) {
        if !isRecording{
            isRecording = true
            recordAndRecognizeSpeech()
        }else{
            isRecording = false
        }
    }

    func didSelectLanguage(lanCode: String) {
        textView.text = lanCode
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: lanCode))
    }
}

