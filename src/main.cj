package hamster_commander

import std.convert.*
import simpleioc.*
import hamster_commander.services.*
import hamster_commander.models.*

main(args: Array<String>): Int64 {
    if (args.isEmpty()) {
        println("What do you want to do? Tell me, baby!");
        return 0;
    }
    // 
    SimpleIoc.default.register<SecretStore>()
    SimpleIoc.default.registerDerived<ICommandService, SparkCommandService>()
    SimpleIoc.default.registerDerived<IHistoryStore, FileHistoryStore>()
    SimpleIoc.default.register<Commander>()
    let commander = SimpleIoc.default.getInstance<Commander>()

    // 处理命令行参数
    let arg0 = args[0]
    match (arg0) {
        case "set-key-secret" where args.size != 3 => println(
            'echo "设置API Key和API Secret: cmdr set-key-secret <key> <secret>"')
        case "set-key-secret" where args.size == 3 =>
            commander.setKeySecret(args[1], args[2])
            println("API Key 和 API Secret 已设置。")
        case "list" =>
            let histories = commander.listHistory()
            for (i in 0..histories.size) {
                println("ID: ${histories[i].id}")
                println("Intent: ${histories[i].intent}")
                println("Command: ${histories[i].command}")
                println()
            }
        case "get" where args.size != 2 => println('echo "获取历史记录: cmdr get <id>"')
        case "get" where args.size == 2 =>
            var h: ?History = None
            try {
                h = commander.getHistory(Int64.parse(args[1]))
            } catch (_: Exception) {
            }
            if (let Some(history) <- h) {
                println(history.command)
            } else {
                println('echo "找不到该历史记录"')
            }
        case "remove" where args.size != 2 => println('echo "删除历史记录: cmdr remove <id>"')
        case "remove" where args.size == 2 =>
            var h: ?History = None
            try {
                h = commander.getHistory(Int64.parse(args[1]))
            } catch (_: Exception) {
            }
            if (let Some(history) <- h) {
                commander.removeHistory(history.id)
                println('echo "删除成功"')
            } else {
                println('echo "找不到该历史记录"')
            }
        case _ => println(commander.generateCommand(arg0))
    }
    return 0;
}
