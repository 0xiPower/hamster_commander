package hamster_commander.test

import std.unittest.*
import std.unittest.testmacro.*
import hamster_commander.*
import crypto.crypto.*
import std.fs.*

@Test
public class SecretStoreTest {
    @TestCase
    public func testSetGet() {
        let secureRandom = SecureRandom();
        let key = "key" + secureRandom.nextInt64().toString();
        let value = "value" + secureRandom.nextInt64().toString();

        let secretStore = SecretStore();
        secretStore.set(key, value);
        let valueFromSecretStore = secretStore.get(key);
        @Expect(valueFromSecretStore, value);
        // 清理测试数据
        File.delete(secretStore.getSecretStoreFilePath(key));
    }
}
