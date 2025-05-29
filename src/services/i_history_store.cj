package hamster_commander.services

import hamster_commander.models.*

public interface IHistoryStore {
    func append(intent: String, command: String): Unit

    func list(): Array<History>

    func get(id: Int64): ?History

    func remove(id: Int64): Unit
}
