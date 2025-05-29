package hamster_commander.test

import std.unittest.*
import std.unittest.testmacro.*
import hamster_commander.*
import crypto.crypto.*
import std.fs.*
import std.unittest.mock.*
import std.unittest.mock.mockmacro.*
import hamster_commander.services.*
import hamster_commander.models.*

@Test
public class CommanderTest {
    @TestCase
    public func setKeySecret_default() {
        let secureRandom = SecureRandom()
        let randomInt16 = secureRandom.nextInt16()
        let key = "key" + randomInt16.toString()
        let secret = "secret" + secureRandom.nextInt16().toString()

        let secretStore = SecretStore()
        let historyStore = mock<IHistoryStore>()
        let commandService = mock<ICommandService>()
        let commander = Commander(secretStore, historyStore, commandService)
        commander.setKeySecret(key, secret)
        let keyFromSecretStore = secretStore.get(Commander.API_KEY_KEY)
        let secretFromSecretStore = secretStore.get(Commander.API_SECRET_EKY)

        @Expect(keyFromSecretStore, key)
        @Expect(secretFromSecretStore, secret)

        File.delete(secretStore.getSecretStoreFilePath(Commander.API_KEY_KEY))
        File.delete(secretStore.getSecretStoreFilePath(Commander.API_SECRET_EKY))
    }

    @TestCase
    public func listHistoryDefault() {
        // Arrange
        let secretStore = SecretStore()
        let historyStore = mock<IHistoryStore>()
        let commandService = mock<ICommandService>()

        let historiesToReturn = [
            History("intent 1", "command 1"),
            History("intent 2", "command 2"),
            History("intent 3", "command 3")
        ]
        @On(historyStore.list()).returns(historiesToReturn)
        // Act
        let commander = Commander(secretStore, historyStore, commandService)
        let histories = commander.listHistory()
        // Assert
        @Expect(histories.size, historiesToReturn.size)
        @Expect(refEq(histories[0], historiesToReturn[0]))
        @Expect(refEq(histories[1], historiesToReturn[1]))
        @Expect(refEq(histories[2], historiesToReturn[2]))
    }

    @TestCase
    public func getHistoryDefault() {
        // Arrange
        let SecretStore = SecretStore()
        let historyStore = mock<IHistoryStore>()
        let commandService = mock<ICommandService>()

        let HistoryToReturn = History("intent 1", "command 1")
        @On(historyStore.get(1)).returns(HistoryToReturn)
        // Act
        let commander = Commander(SecretStore, historyStore, commandService)
        let history = commander.getHistory(1)
        // Assert
        @Expect(history.isSome())
        @Expect(refEq(history.getOrThrow(), HistoryToReturn))
    }

    @TestCase
    public func removeHistoryDefault() {
        // Arrange
        let secretStore = SecretStore()
        let historyStore = mock<IHistoryStore>()
        let commandService = mock<ICommandService>()

        @On(historyStore.remove(1)).returns()

        // Act
        let commander = Commander(secretStore, historyStore, commandService)
        let removedHistory = commander.removeHistory(1)

        // Assert
        Verify.that(@Called(historyStore.remove(1)))
    }

    @TestCase
    public func generateCommandDefult() {
        // Arrange
        let secretStore = SecretStore()
        let historyStore = mock<IHistoryStore>()
        let commandService = mock<ICommandService>()

        let intent = "intent"
        let commandToReturn = "command"
        @On(commandService.generateCommand(intent)).returns(commandToReturn)
        @On(historyStore.append(intent, commandToReturn)).returns()

        // Act
        let commander = Commander(secretStore, historyStore, commandService)
        let command = commander.generateCommand(intent)

        // Assert
        @Expect(command, commandToReturn)
        Verify.that(@Called(historyStore.append(intent, commandToReturn)))
    }
}
