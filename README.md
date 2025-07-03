# Navatech - Flutter Assignment

## Features Implemented

- Vertically scrollable albums (infinite)
- Each album has horizontally scrollable photos (independent and infinite)
- Infinite scroll behavior in both directions using modular math
- Fallback support:
    - API → Hive cache → Local assets (JSON)
    - Broken image URLs → `https://dummyimage.com` placeholders
- Clean BLoC architecture
- Local caching via Hive for offline support

## API Used

- Albums: `https://jsonplaceholder.typicode.com/albums`
- Photos: `https://jsonplaceholder.typicode.com/photos?albumId=`

## How It Works

- On launch, the app attempts to load albums via API.
- If the API fails:
    - Falls back to local Hive cache
    - Falls back to bundled JSON assets (`assets/albums.json`, `photos_X.json`)
- If image fails to load from the original source, the app displays a fallback using dummyimage.com

## Project Structure

- `bloc/` - AlbumBloc and PhotoBloc (BLoC pattern)
- `data/` - Remote API and local storage service
- `models/` - Hive-backed models
- `screens/` - Home UI with scroll logic
- `widgets/` - Reusable UI components