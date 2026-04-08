//
//  PlayerViewController.swift
//  EchoShelf
//
//  Created by Ibrahim Kolchi on 24.02.26.
//
import UIKit
import Kingfisher

final class PlayerViewController: UIViewController {

    private let viewModel = PlayerViewModel()
    private let gradientLayer = CAGradientLayer()

    private lazy var closeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.down")
        config.baseForegroundColor = UIColor(named: "OnDarkTextPrimary")
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var coverContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "FillGlassMedium")
        v.layer.cornerRadius = 24
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.4
        v.layer.shadowRadius = 20
        v.layer.shadowOffset = CGSize(width: 0, height: 10)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.image = UIImage(systemName: "building.columns.fill")
        iv.tintColor = UIColor(named: "OnDarkTextSecondary")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        lbl.textColor = UIColor(named: "OnDarkTextPrimary")
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = UIColor(named: "OnDarkText70")
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var progressSlider: UISlider = {
        let sl = UISlider()
        sl.minimumTrackTintColor = UIColor(named: "PrimaryGradientStart")
        sl.maximumTrackTintColor = UIColor(named: "SliderTrackMaximum")
        sl.translatesAutoresizingMaskIntoConstraints = false
        return sl
    }()

    private lazy var currentTimeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "OnDarkText70")
        lbl.font = .systemFont(ofSize: 13)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var durationLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "OnDarkText70")
        lbl.font = .systemFont(ofSize: 13)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var playButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        btn.tintColor = UIColor(named: "OnDarkTextPrimary")
        btn.backgroundColor = UIColor(named: "PrimaryGradientStart")
        btn.layer.cornerRadius = 35
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var rewindButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "gobackward.15"), for: .normal)
        btn.tintColor = UIColor(named: "OnDarkTextPrimary")
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var forwardButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "goforward.15"), for: .normal)
        btn.tintColor = UIColor(named: "OnDarkTextPrimary")
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupUI()
        setupActions()
        bindViewModel()
        configureData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(named: "PlayerGradientTop")!.cgColor,
            UIColor(named: "PlayerGradientBottom")!.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupUI() {
        coverContainerView.addSubview(coverImageView)
        view.addSubview(closeButton)
        view.addSubview(coverContainerView)
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(progressSlider)
        view.addSubview(currentTimeLabel)
        view.addSubview(durationLabel)
        view.addSubview(rewindButton)
        view.addSubview(playButton)
        view.addSubview(forwardButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            coverContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            coverContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coverContainerView.widthAnchor.constraint(equalToConstant: 260),
            coverContainerView.heightAnchor.constraint(equalToConstant: 300),

            coverImageView.topAnchor.constraint(equalTo: coverContainerView.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: coverContainerView.bottomAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: coverContainerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: coverContainerView.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: coverContainerView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            progressSlider.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 32),
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            currentTimeLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 4),
            currentTimeLabel.leadingAnchor.constraint(equalTo: progressSlider.leadingAnchor),

            durationLabel.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 4),
            durationLabel.trailingAnchor.constraint(equalTo: progressSlider.trailingAnchor),

            rewindButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            rewindButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -32),
            rewindButton.widthAnchor.constraint(equalToConstant: 44),
            rewindButton.heightAnchor.constraint(equalToConstant: 44),

            playButton.topAnchor.constraint(equalTo: progressSlider.bottomAnchor, constant: 40),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 70),
            playButton.heightAnchor.constraint(equalToConstant: 70),

            forwardButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            forwardButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 32),
            forwardButton.widthAnchor.constraint(equalToConstant: 44),
            forwardButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        rewindButton.addTarget(self, action: #selector(rewindTapped), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardTapped), for: .touchUpInside)
        progressSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
    }

    private func bindViewModel() {
        viewModel.onProgressUpdated = { [weak self] in
            guard let self else { return }
            self.progressSlider.value = self.viewModel.progress
            self.currentTimeLabel.text = self.viewModel.currentTimeText
            self.durationLabel.text = self.viewModel.durationText
            self.updatePlayButton()
        }
    }

    private func configureData() {
        guard let book = viewModel.currentBook else { return }
        titleLabel.text = book.title
        authorLabel.text = book.authorName
        currentTimeLabel.text = viewModel.currentTimeText
        durationLabel.text = viewModel.durationText
        progressSlider.value = viewModel.progress
        updatePlayButton()

        let url = book.coverURL ?? book.archiveCoverURL
        coverImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "building.columns.fill"))
    }

    private func updatePlayButton() {
        let icon = viewModel.isPlaying ? "pause.fill" : "play.fill"
        playButton.setImage(UIImage(systemName: icon), for: .normal)
    }

    @objc private func closeTapped() { dismiss(animated: true) }

    @objc private func playTapped() {
        viewModel.togglePlayPause()
        updatePlayButton()
    }

    @objc private func rewindTapped() {
        let newTime = max(0, PlayerManager.shared.currentTime - 15)
        viewModel.seek(to: Float(newTime / PlayerManager.shared.duration))
    }

    @objc private func forwardTapped() {
        let newTime = min(PlayerManager.shared.duration, PlayerManager.shared.currentTime + 15)
        viewModel.seek(to: Float(newTime / PlayerManager.shared.duration))
    }

    @objc private func sliderChanged() {
        viewModel.seek(to: progressSlider.value)
    }
}
