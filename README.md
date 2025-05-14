# Basic Http Manager


基于Flutter和Dio的HTTP请求管理器，简化API调用和网络请求。

## 安装 💻

**❗ 使用Basic Http Manager前，需要先安装[Flutter SDK][flutter_install_link]。**

通过`flutter pub add`安装:

```sh
dart pub add basic_http_manager
```

## 功能特点 ✨

- 简单易用的HTTP请求接口(GET, POST, PUT, DELETE)
- 可配置的拦截器
- 灵活的请求头管理
- 业务错误码处理
- 超时控制

## 使用示例 📝

```dart
// 初始化HTTP管理器
final httpManager = BasicHttpManager(
  managerConfig: HttpManagerConfig(
    baseUrl: 'https://api.example.com',
    interceptors: [LogInterceptor()],
    httpHeaderGetter: () => {'Authorization': 'Bearer token'},
  ),
);

// 发送GET请求
final response = await httpManager.get('/users');

// 发送POST请求
final response = await httpManager.post(
  '/users',
  params: {'name': 'John', 'age': 30},
);
```

## 运行测试 🧪

运行所有单元测试:

```sh
very_good test --coverage
```

查看生成的覆盖率报告:

```sh
# 生成覆盖率报告
genhtml coverage/lcov.info -o coverage/

# 打开覆盖率报告
open coverage/index.html
```

[flutter_install_link]: https://docs.flutter.dev/get-started/install
