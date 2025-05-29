package hamster_commander.services

import hamster_commander.models.*
import std.os.*
import std.fs.*
import std.io.*
import std.collection.*
import serialization.serialization.*
import encoding.json.*

public class FileHistoryStore <: IHistoryStore {
    public static let historyFilePath: Path
    public static let newHistoryFilePath: Path
    // 历史记录存储路径
    static init() {
        let historyStorePath = currentDir().info.path.join(".hamster_commander")
        if (!Directory.exists(historyStorePath)) {
            Directory.create(historyStorePath, recursive: true)
        }
        historyFilePath = historyStorePath.join("history")
        newHistoryFilePath = historyStorePath.join("history.new")
    }
    // 存储历史记录的文件
    public func append(intent: String, command: String): Unit {
        let history = History(intent, command)
        let historyJson = history.serialize().toJson().toJsonString().replace("\n", "")
        try (historyFile = File(historyFilePath, OpenOption.CreateOrAppend), stringWriter = StringWriter(historyFile)) {
            stringWriter.writeln(historyJson)
        }
    }
    // 获取所有历史记录
    public func list(): Array<History> {
        let historyList = ArrayList<History>()
        try (historyFile = File.openRead(historyFilePath), stringReader = StringReader(historyFile)) {
            while (let Some(line) <- stringReader.readln()) {
                let json = line.trimAscii()
                if (json.isEmpty()) {
                    continue
                }
                let history = History.deserialize(DataModel.fromJson(JsonValue.fromStr(json)))
                history.id = historyList.size
                historyList.append(history)
            }
        }
        return historyList.toArray()
    }
    // 获取指定 ID 的历史记录
    public func get(id: Int64): Option<History> {
        try (historyFile = File.openRead(historyFilePath), stringReader = StringReader(historyFile)) {
            var lineId = -1
            while (let Some(line) <- stringReader.readln()) {
                lineId++
                let json = line.trimAscii()
                if (lineId != id) {
                    continue
                }
                if (json.isEmpty()) {
                    return None
                }
                let history = History.deserialize(DataModel.fromJson(JsonValue.fromStr(json)))
                history.id = id
                return history
            }
        }
        return None
    }
    // 删除指定 ID 的历史记录
    public func remove(id: Int64): Unit {
        try (historyFile = File.openRead(historyFilePath), stringReader = StringReader(historyFile), newHistoryFile = File
            .create(newHistoryFilePath), stringWriter = StringWriter(newHistoryFile)) {
            var lineId = -1
            while (let Some(line) <- stringReader.readln()) {
                lineId++
                let json = line.trimAscii()
                if (lineId == id) {
                    continue
                }
                stringWriter.writeln(json)
            }
        }
        File.delete(historyFilePath)
        File.move(newHistoryFilePath, historyFilePath, true)
    }
}
