# Loading Gallery App

Gallery App implementing infinite scroll feed via Grid view and Scroll

## Preview:
<p align="center">
  <img src="https://github.com/user-attachments/assets/7e57c14c-b710-4a19-88df-0345f601fc9a" width="33%">
  <img src="https://github.com/user-attachments/assets/a8fbaa3f-1256-47b9-a338-d7464a587d88" width="33%">
  <img src="https://i.giphy.com/52t1NMsyJV0cqVWs1r.webp" width="33%">
</p>



## Technical Features:
### 📸 Loading Images

Loading images are implemented via [Unsplash API](https://unsplash.com/developers).
We fetch `imageURL`, convert it into `UIImage`, and the main feature is **infinite scrolling**: the next pack of images is preloaded before the user reaches the end.

Each grid cell uses `.task(id:)` to check if the loading trigger is reached:

    .task(id: look.id) {
        await viewModel.onScrollReachedThreshold(current: look)
    }

📌 With 24 images per page, I decided to trigger the next load when **half of the images** are already displayed, so the app has enough time to fetch the next page.  
That’s why `thresholdIndexOffset = 13`.

    func onScrollReachedThreshold(current: Look) async {
        guard let index = looks.firstIndex(where: { $0.id == current.id })
        else { return }
        
        let thresholdIndex = looks.count - thresholdIndexOffset
        if index == thresholdIndex && !isLoading
            && !loadedPages.contains(currentPage + 1)
        {
            print("Reached look to load more - current index = \(index)")
            await loadNextPageOfImages()
        }
    }

One **shared ViewModel** is used for both screens (grid and scroll), which helps to:
- have a **single source of truth** for images (no reloading or duplicating data),
- keep `selectedImageIndex` across navigation,
- open the scroll view **directly at the tapped image** from the grid.

---

### 🧭 Navigation

Navigation is implemented using **Coordinator + Router** pattern:

- **Router** → technical layer that executes navigation commands (encapsulates transition details).  
- **Coordinator** → manages screen flows and creates/configures SwiftUI views.  

### Grid → Scroll transition (preserving position)

In `LooksGridViewScreen`, tapping an image calls the closure `onImageTap(index)`:

    struct LooksGridViewScreen: View {
        var onImageTap: (Int) -> Void
        
        private var gridView: some View {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.looks.indices, id: \.self) { index in
                    Button {
                        onImageTap(index)
                    } label: {
                        // image cell
                    }
                }
            }
        }
    }

In `LooksScrollViewScreen`, a **ScrollViewReader** is used to scroll to the previously selected index:

    struct LooksScrollViewScreen: View {
        var body: some View {
            ScrollViewReader { proxy in
                ScrollView {
                    // images
                }
                .onAppear {
                    Task {
                        withAnimation(.none) {
                            proxy.scrollTo(viewModel.selectedIndex, anchor: .top)
                        }
                    }
                }
            }
        }
    }

### Coordinator

`LooksCoordinator` manages the entire flow:  

    final class LooksCoordinator: ObservableObject {
        private let router: AppRouter
        private let looksViewModel = LooksViewModel()

        init(router: AppRouter) {
            self.router = router
        }

        func start() -> some View {
            LooksGridViewScreen(
                onImageTap: { [weak self] index in
                    self?.looksViewModel.selectedIndex = index
                    self?.router.push(.scrollView)
                },
                viewModel: looksViewModel
            )
        }
        
        func scrollViewScreen() -> some View {
            LooksScrollViewScreen(
                viewModel: looksViewModel,
                onBack: { [weak self] in
                    self?.router.pop()
                }
            )
        }
    }


## To do:
- add search for pictures
- redesign toolbar in scroll View

## Author
[GitHub](https://github.com/ilyakol123)
