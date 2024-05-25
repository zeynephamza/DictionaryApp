# Dictionary App

## Overview
Dictionary App is an iOS application developed in swift. It provides the users the word definitions, synonyms, and audio pronunciations for the word they have entered. Dictionary uses the VIPER architecture and uses Alamofire Library. 

<img src="https://raw.githubusercontent.com/codytwinton/SwiftyVIPER/1.2.3/Assets/SwiftyVIPER.png" alt="Swift Icon" height="120px" width="330px"> <img src="https://avatars.githubusercontent.com/u/7774181?v=4" alt="Swift Icon" height="120px" width="150px">




## Architecture
The app is modular and uses a custom package for the API service. 
The application uses the VIPER architecture pattern:
- **View**: Displays the data and handles user interaction.
- **Interactor**: Contains the business logic and communicates with the network layer or databases.
- **Presenter**: Acts as a bridge between the View and the Interactor, handling the presentation logic.
- **Entity**: Represents the data model.
- **Router**: Manages navigation and routing between screens.

## Scenes

The app was developed programmatically. Only recent searches are implemented using Nib.

1. **Main Screen**:
   - Contains a search bar on top of the screen where users can enter the word of their choice, clicking the search button or pressing enter on the keyboard searches the word on the api. If the api returns a valid respond, the app goes in to the Detail Screen. If the response is not valid an error message pops up.
   - Displays the last five searches below the search bar. User can tap on these recent searches to search for that word as if they have typed it in the search bar. These words are are saved in userdefaults so they are consistent through different app launches.

2. **Detail Screen**:
   - Displays the definitions of the searched word using Dictionary API (`https://api.dictionaryapi.dev/api/v2/entries/en/{word}`).
   - Displays the top 5 synonyms from the Datamuse API (`https://api.datamuse.com/words?rel_syn={word}`) on the bottom of the screen after definitions.
   - A button on top right corner reads the word out loud if it is available.
   - User can filter the selected definition type or combine the filters by pressing another while one is selected already. 

## Tests
- UITests for more than 5 cases are implemented.
- Unit tests for more than 5 functions are implemented.
- <img width="313" alt="Screenshot 2024-05-25 at 21 16 11" src="https://github.com/zeynephamza/DictionaryApp/assets/15521642/8781157c-f469-48a6-91c2-4d165c073492">

## Screenshots
<img src="https://github.com/zeynephamza/DictionaryApp/assets/15521642/a8b8d071-f2c0-4305-8e8f-d2a1ff18da9b" alt="Search Screen" height="450px" width="200px">
<img src="https://github.com/zeynephamza/DictionaryApp/assets/15521642/26ae8935-715d-4603-9f2d-3c49f5ea159a" alt="Detail Screen" height="450px" width="200px">
<img src="https://github.com/zeynephamza/DictionaryApp/assets/15521642/79e9dab5-99bd-4cae-bb58-51530eb63d5d" alt="Filter" height="450px" width="200px">
<img src="https://github.com/zeynephamza/DictionaryApp/assets/15521642/f381646d-29de-4f7e-b9af-8a6f28594f27" alt="Error Screen" height="450px" width="200px">


## Demo Video
Watch the demo to see the app usage


https://github.com/zeynephamza/DictionaryApp/assets/15521642/0084cc41-7f21-41be-97af-1f33d242a3a6



## Future Improvements
- Support for other languages

## Author
Zeynep Özcan
