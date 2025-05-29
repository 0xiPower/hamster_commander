package hamster_commander.models

import serialization.serialization.*

public class History <: Serializable<History> {
    public var id: Int64 = 0
    public History(
        public var intent: String,
        public var command: String
    ) {}
    // 使用给定的 intent 和命令初始化新的 History 实例。
    public func serialize(): DataModel {
        DataModelStruct().add(field<String>("intent", intent)).add(field<String>("command", command))
    }
    // 将当前 History 实例序列化为 DataModel。
    public static func deserialize(dm: DataModel): History {
        let dms = match (dm) {
            case d: DataModelStruct => d
            case _ => throw Exception("this data is not DataModelStruct")
        }
        History(
            String.deserialize(dms.get("intent")),
            String.deserialize(dms.get("command"))
        )
    }
}
