package hamster_commander

import hamster_commander_toolkit.*
import hamster_commander.services.*
import hamster_commander.models.*

public class Commander {
    static const API_KEY_KEY = "apiKey"
    static const API_SECRET_EKY = "apiSecret"

    // 存储密钥的 SecretStore 实例
    public Commander(
        private let secretStore: SecretStore,
        private let historyStore: IHistoryStore,
        private let commandService: ICommandService
    ) {}

    // Public 方法，用于根据 intent 生成命令
    public func generateCommand(intent: String): String {
        let command = commandService.generateCommand(intent)
        historyStore.append(intent, command)
        return command
    }

    // 
    public func setKeySecret(key: String, secret: String): Unit {
        secretStore.set(API_KEY_KEY, key)
        secretStore.set(API_SECRET_EKY, secret)
    }

    //
    public func listHistory(): Array<History> {
        return historyStore.list()
    }

    //
    public func getHistory(id: Int64): ?History {
        return historyStore.get(id)
    }
    
    //
    public func removeHistory(id: Int64): Unit {
        historyStore.remove(id)
    }
}
