package hamster_commander.services

import std.os.*
import std.fs.*
import std.io.*
import crypto.crypto.*

public class SecretStore {
    // 获取当前目录并加入".env"路径
    let secretStorePath = currentDir().info.path.join(".env")
    let key = "hamster_commandr"
    let iv = "commanderhamster"
    let sm4: SM4

    public init() {
        sm4 = SM4(OperationMode.CBC, key.toArray(), iv: iv.toArray())
    }

    public func getSecretStoreFilePath(key: String): Path {
        return secretStorePath.join(key)
    }

    public func set(key: String, value: String): Unit {
        if (!Directory.exists(secretStorePath)) {
            Directory.create(secretStorePath, recursive: true);
        }
        let secretStoreFilePath = getSecretStoreFilePath(key)
        // 如果文件存在则删除
        if (File.exists(secretStoreFilePath)) {
            // 如果文件存在，删除它
            File.delete(secretStoreFilePath)
        }
        try (secretStoreFile = File.create(secretStoreFilePath)) {
            secretStoreFile.write(sm4.encrypt(value.toArray()));
        }
    }

    public func get(key: String): ?String {
        let secretStoreFilePath = getSecretStoreFilePath(key)
        // 如果文件不存在，返回 None
        if (!File.exists(secretStoreFilePath)) {
            return None
        }
        try (secretStoreFile = File.openRead(secretStoreFilePath)) {
            return String.fromUtf8(sm4.decrypt(secretStoreFile.readToEnd()));
        }
        return None
    }
}
