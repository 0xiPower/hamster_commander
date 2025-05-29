package hamster_commander.services

import hamster_commander_toolkit.*
import hamster_commander.services.command_service_comstant.*

public class SparkCommandService <: ICommandService {
    public SparkCommandService(let secretStore: SecretStore) {}

    public func generateCommand(intent: String): String {
        let apiKey = secretStore.get(API_KEY_KEY)
        let apiSecret = secretStore.get(API_SECRET_EKY)

        if (apiKey.isNone() || apiSecret.isNone()) {
            return "echo \"请首先设置 API key 和 API Secret: cmdr set-key-secret <key> <secret>\""
        }
        let commandGenerator = SparkCommandGenerator(apiKey.getOrThrow(), apiSecret.getOrThrow())
        return commandGenerator.generateCommand(intent)
    }
}
