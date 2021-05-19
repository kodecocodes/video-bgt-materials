/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import BackgroundTasks

class MusicListViewController: UIViewController {
	private let musicService = MusicListService()
	private var musicTitles: [MusicTitle] = []
	private let taskIdentifier = "com.raywenderlich.BackgroundTasks.fetch"
	private let taskIdentifierProcessing = "com.raywenderlich.BackgroundTasks.processing"

	@IBOutlet weak var collectionView: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()

		BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: DispatchQueue.global()) { task in
			// Code to be added
		}

		BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifierProcessing, using: DispatchQueue.global()) { task in
			// Code to be added
		}
		
		downloadMusicTitles()
	}

	private func downloadMusicTitles() {
		musicService.downloadMusicTitles { music in
			guard let musicTitles = music else { return }
			self.musicTitles = musicTitles
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
}

extension MusicListViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		musicTitles.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
		cell.addSubview(imageView)

		let musicTitle = musicTitles[indexPath.row]
		let url = URL(string: musicTitle.artworkUrl100 ?? "")

		if let url = url {
			DispatchQueue.global().async {
				let data = try? Data(contentsOf: url)
				DispatchQueue.main.async {
					guard let data = data else { return }
					imageView.image = UIImage(data: data)
				}
			}
		}
		return cell
	}
}
