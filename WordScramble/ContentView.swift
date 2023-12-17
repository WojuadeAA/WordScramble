//
//  ContentView.swift
//  WordScramble
//
//  Created by Wojuade Abdul Afeez on 14/12/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingAlert = false
    var body: some View {
        
        NavigationStack{
            List{
                Section{
                    TextField("Enter Your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                       
                }
                
                Section {
                    ForEach(usedWords, id: \.self){word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        
                    }
                }
            }
            .listStyle(<#T##style: ListStyle##ListStyle#>)
            .navigationTitle(rootWord)
            .navigationBarTitleDisplayMode(.large)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingAlert){
                Button("Ok"){}
            }message: {
                Text(errorMessage)
            }
        }
       
    }
    
    
   
    
    func isOriginal(word: String)-> Bool{
     return   !usedWords.contains(word)
    }
    
    func isPossibleWord(word : String )-> Bool{
        var tempWord  = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            }else{
                return false
            }
        }
        return true
    }

    func isRealEnglishWord(word: String)-> Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let missSpelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: true, language: "en")
        
        
        return missSpelledRange.location == NSNotFound
    }
    func wordError(title: String, message: String){
        errorTitle = title
        errorMessage = message
        showingAlert = true
    }
    
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {return }
        
        guard isOriginal(word: answer)
        else{
            wordError(title: "word used already", message: "Be more Original")
            return
        }
        guard isRealEnglishWord(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make the up you know")
        return
        }
        guard isPossibleWord(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell \(newWord) from \(rootWord)")
       return
        }
        
      
        withAnimation{
        usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    
    
    func startGame( ) {
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String (contentsOf: startWordsUrl){
                let allWords = startWords.components(separatedBy: .newlines)
                rootWord = allWords.randomElement() ?? "SilkWorm"
                return
            }
                
        }
        fatalError("Could not load start.txt from bundle")
    }

    
    func textStrings(){
        let input = "A B C"
        let arrayOfString = input.components(separatedBy: "");
        let randomString = arrayOfString.randomElement()
        let whiteSpaceText = "sesfrs s sgs sg"
        let trimmed = whiteSpaceText.trimmingCharacters(in: .whitespaces)
    }
    
    func checkMissSpelledWordIn(word: String) -> Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let missSpelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let allGood = missSpelledRange.location == NSNotFound
    return allGood
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
