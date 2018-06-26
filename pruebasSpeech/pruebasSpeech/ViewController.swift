//
//  ViewController.swift
//  pruebasSpeech
//
//  Created by Ana Cristina Betan on 11/04/18.
//  Copyright © 2018 Ana Cristina Betan. All rights reserved.
//

import UIKit
import Speech
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer() //Puede tener un init?
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    //Va a grabar o pausar
    var isRecording = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func recordAndRecognizeSpeech( ){
        let node = audioEngine.inputNode //Crea nodo que recibe audio a bits
        let recordingFormat = node.outputFormat(forBus: 0) //En formato for Bus
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, audioTime) in
            self.request.append(buffer)
            
        } //Fujo de bits - closure {(  ) in code}  No se ejecuta la línea completa, lo que está adentro se ejecuta hasta que el nodo termine de iterar = ASÍNCRONAS; puedes ir haciendo lo otro en lo que recibe FRIJOLES
        audioEngine.prepare( )
            do { //Try maneja tipos de errores en lugar de crashear  se maneja siempre dentro de un do
                try audioEngine.start( )
            } catch { //Ya viene con un error
                print("Falló al recibir audio \(error.localizedDescription)")
        }
        guard let speechRecognizer = speechRecognizer else {
            return //Para asegurarnos que existe el objeto y que no va a ser un optional, solo nos vamos a asegurar que exista; es como un if al revés
        }
        if speechRecognizer.isAvailable{ //Si tiene o no micrófono, si dio acceso o no
            recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { (result, error) in
                if let result = result { //Es la misma función que un guard let, evita anida
                    let bestString = result.bestTranscription.formattedString //Ya recibió texto, recibe la botella de agua. va concatenando, pero ya va llegando en paquetito
                    self.textView.text = bestString
                }
            })
        }
    }
    
    @IBAction func startOp(_ sender: UIButton) {
        if !isRecording {
            isRecording = true
            recordAndRecognizeSpeech( )
        } else {
            isRecording = false
        }
    }
    

}

