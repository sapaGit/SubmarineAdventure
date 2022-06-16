//
//  User.swift
//  SubmarineAdventure
//
//  Created by Sergey Pavlov on 02.06.2022.
//

import Foundation
class User: Codable {
    
    var submarineColor = "SubmarineGrey"
    var userName: String
    var speed = 2
    var score = [0, 0, 0, 0, 0]
    var scoreName = ["User","User","User","User","User"]
    
    init(userName: String) {
        self.userName = userName
    }
        // формируем энум из свойств класса, и тип String и СodingKey обязательно указывать
        public enum CodingKeys: String, CodingKey {
            case submarineColor, userName, speed, score, scoreName
        }
        //метод преобразует Data в объект
        required public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.submarineColor = try container.decode(String.self, forKey: .submarineColor)
            self.userName = try container.decode(String.self, forKey: .userName)
            self.speed = try container.decode(Int.self, forKey: .speed)
            self.score = try container.decode([Int].self, forKey: .score)
            self.scoreName = try container.decode([String].self, forKey: .scoreName)
        }
        // метод создает контейнер и упаковывает его в data. Внутрь контейнера складываем по отдельности каждое свойство.
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.submarineColor, forKey: .submarineColor)
            try container.encode(self.userName, forKey: .userName)
            try container.encode(self.speed, forKey: .speed)
            try container.encode(self.score, forKey: .score)
            try container.encode(self.scoreName, forKey: .scoreName)
            
        }
}
