//
//  ViewController.swift
//  TabGenerator
//
//  Created by Мельник Всеволод on 24.05.2023.
//

import UIKit
import Beethoven
import Pitchy
import AVFoundation

class TabGeneratorController: UIViewController {
    private struct Constants {
        static let levelThreshold: Float = -30
        static let estimationStrategy: EstimationStrategy = .yin
        static let notesPerFrame: Int = 16
        static let start = "Начать запись"
        static let stop = "Стоп"
    }

    let tabView = TabGeneratorView()
    let recordButton = UIButton()

    lazy var pitchEngine: PitchEngine = { [weak self] in
        let config = Config(estimationStrategy: Constants.estimationStrategy)
        let pitchEngine = PitchEngine(config: config, delegate: self)
        pitchEngine.levelThreshold = Constants.levelThreshold
        return pitchEngine
    }()

    var tab: TabModel = TabModel(tuning: .standart, sounds: [])
    var timer: Int = 0
    private var currentFrame: Int = 0
    private var recording: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        configureAudioCapture()
    }

    private func configureAudioCapture() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print("Permission granted")
        case AVAudioSession.RecordPermission.denied:
            print("Pemission denied")
        case AVAudioSession.RecordPermission.undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                // Handle granted
            })
        @unknown default:
            print("Error happend when asking for permission")
        }
    }

    private func configureUI() {
        configureRecordButton()
        configureTabView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    private func configureRecordButton() {
        view.addSubview(recordButton)
        recordButton.setTitle(Constants.start, for: .normal)
        recordButton.pinCenterX(to: view)
        recordButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        recordButton.addTarget(self, action: #selector(startStopRecording), for: .touchUpInside)
    }

    private func configureTabView() {
        view.addSubview(tabView)
        tabView.pinHorizontal(to: view)
        tabView.pinBottom(to: recordButton.topAnchor)
        tabView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        tabView.tabFrameView.collectionView.delegate = self
        tabView.tabFrameView.collectionView.dataSource = self
    }

    @objc
    private func startStopRecording() {
        if recording {
            pitchEngine.stop()
            recordButton.setTitle(Constants.start, for: .normal)
            recording = false
            currentFrame = 0
            TabSaveWorker.shared.save(name: tabView.title.text ?? "testTab", tab: tab)
        } else {
            tab = TabModel(tuning: .standart, sounds: [])
            pitchEngine.start()
            recordButton.setTitle(Constants.stop, for: .normal)
            recording = true
        }
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension TabGeneratorController: PitchEngineDelegate {
    func pitchEngine(_ pitchEngine: PitchEngine, didReceivePitch pitch: Pitch) {
        let offsetPercentage = pitch.closestOffset.percentage
        let absOffsetPercentage = abs(offsetPercentage)

        timer += 1
        tabView.showNote(string: pitch.note.string, offset: String(format:"%.2f", absOffsetPercentage) + "%")
        if timer > 1 {
            var newBar = [
                Sound.noSound,
                Sound.noSound,
                Sound.noSound,
                Sound.noSound,
                Sound.noSound,
                Sound.noSound
            ]
            let sound = TabGeneratorWorker.shared.getTabSound(note: pitch.note.letter.rawValue, octave: pitch.note.octave)
            switch sound {
            case .sound(let tabSound):
                newBar[tabSound.string - 1] = sound
            case .noSound:
                break
            }

            tab.sounds.append(newBar)
            currentFrame = tab.sounds.count / Constants.notesPerFrame
            tabView.tabFrameView.collectionView.reloadData()
            timer = 0
        }
        
        guard absOffsetPercentage > 1.0 else {
            return
        }
    }

    func pitchEngine(_ pitchEngine: PitchEngine, didReceiveError error: Error) {
        print(error)
    }

    public func pitchEngineWentBelowLevelThreshold(_ pitchEngine: PitchEngine) {
        timer += 1
        if timer > 1 {
            print("Below level threshold")
            tab.sounds.append([
                Sound.noSound,
                Sound.noSound,
                Sound.noSound,
                Sound.noSound,
                Sound.noSound,
                Sound.noSound
            ])
            currentFrame = tab.sounds.count / Constants.notesPerFrame
            tabView.tabFrameView.collectionView.reloadData()
            timer = 0
        }
    }
}

extension TabGeneratorController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        96
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundCell.reuseIdentifier, for: indexPath) as? SoundCell else {
            return UICollectionViewCell()
        }
        cell.configureUI()
        let row = indexPath.item / Constants.notesPerFrame
        let column = currentFrame * Constants.notesPerFrame + indexPath.item % Constants.notesPerFrame
        if tab.sounds.count > column && tab.sounds[column].count > row {
            switch tab.sounds[column][row] {
            case .sound(let sound):
                cell.numberLabel.text = String(sound.fret)
            case .noSound:
                cell.numberLabel.text = " "
            }
        } else {
            cell.numberLabel.text = " "
        }
        if tab.sounds.count - 1 == column {
            cell.play()
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.width / CGFloat(Constants.notesPerFrame),
            height: collectionView.frame.height / 6
        )
    }
}
