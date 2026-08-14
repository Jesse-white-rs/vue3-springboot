# 通用前后端管理系统 (RS)

一套基于 **Spring Boot** 后端 + **Vue 3** 前端的通用后台管理系统，包含权限管理（用户 / 角色 / 菜单 / 部门）、动态路由、WebSocket 通信、阿里云 OSS 对象存储等能力。

> 作者：RWG ｜ QQ：1940449715

---

## 技术栈

### 后端 (RS_BACKEND)
- **开发语言**：Java 8
- **框架**：Spring Boot 2.5.14
- **安全**：Spring Security
- **ORM**：MyBatis Plus 3.4.3
- **数据库**：MySQL 8.0（Druid 连接池）
- **缓存**：Redis（Redisson / Spring Data Redis）
- **接口文档**：Knife4j 3.0.3
- **认证**：JWT (jjwt 0.9.1)
- **对象存储**：阿里云 OSS
- **其他**：PageHelper 分页、WebSocket、FastJSON

后端采用 **Maven 多模块** 结构：

| 模块 | 说明 |
| --- | --- |
| `RS_web` | 启动模块，包含启动类 `RsWebApplication`、Controller、配置 |
| `RS_core` | 核心业务 / 领域模型 |
| `RS_util` | 通用工具类 |
| `RS_exception` | 统一异常处理 |
| `RS_common` | 公共组件 / 常量 |

### 前端 (RS_FRONTEND)
- **框架**：Vue 3 + TypeScript + Vite 5
- **UI 组件库**：Element Plus + TDesign Vue Next
- **状态管理**：Pinia
- **路由**：Vue Router 4
- **图表**：ECharts 5
- **HTTP**：Axios
- **其他**：Mock.js、NProgress、html2canvas + jsPDF（导出）、Dexie（IndexedDB）

---

## 目录结构

```
通用前后端管理系统/
├── Dockerfile              # 容器化部署配置（前端 Node 镜像）
├── mysql-data/             # MySQL 数据目录（本地 / 容器挂载，不入库）
├── RS_BACKEND/             # 后端工程
│   ├── pom.xml             # Maven 父工程（多模块聚合）
│   ├── sql/                # 数据库初始化 SQL（建表 + 初始化数据）
│   ├── RS_web/             # 启动模块
│   ├── RS_core/            # 核心模块
│   ├── RS_util/            # 工具模块
│   ├── RS_exception/       # 异常模块
│   └── RS_common/          # 公共模块
└── RS_FRONTEND/            # 前端工程
    ├── src/                # 源码（Vue 组件 / TS / 路由 / 状态）
    ├── public/             # 静态资源
    ├── .env                # 环境变量（API 地址，见下方说明）
    ├── vite.config.ts      # Vite 配置（端口 8888）
    └── package.json
```

---

## 环境要求

- **JDK**：1.8
- **Maven**：3.x
- **Node.js**：20.x
- **MySQL**：8.0
- **Redis**：6.x+
- **阿里云 OSS**（如需使用文件上传功能）

---

## 快速开始

### 1. 数据库初始化
在 MySQL 中创建数据库（默认 `pc_assist`），并执行 `RS_BACKEND/sql/` 目录下的全部 SQL 脚本：

```bash
mysql -u root -p pc_assist < RS_BACKEND/sql/dept.sql
mysql -u root -p pc_assist < RS_BACKEND/sql/menu.sql
# ... 依次执行目录内其他 .sql 文件
```

### 2. 后端配置与启动

修改 `RS_BACKEND/RS_web/src/main/resources/application-dev.yml`，填写你的数据库、Redis、OSS 等连接信息：

```yaml
efps:
  datasource:
    host: 127.0.0.1
    port: 3306
    database: pc_assist
    username: root
    password: your_password
  alioss:
    endpoint: oss-cn-xx.aliyuncs.com
    access-key: your_access_key
    secret-key: your_secret_key
    bucket: your_bucket
spring:
  redis:
    host: 127.0.0.1
    port: 6379
```

> 注意：该文件含敏感凭据，**请勿提交到仓库**（已被 `.gitignore` 忽略）。可用 `application-dev.yml.example` 作为模板。

使用 Maven 打包并运行：

```bash
cd RS_BACKEND
mvn clean package
java -jar RS_web/target/RS_web-1.0-SNAPSHOT.jar
```

或直接在 IDE 中运行 `com.rs.RsWebApplication`。后端默认端口 `8080`，接口上下文路径 `/assist-backend/`。

接口文档（Knife4j）：`http://localhost:8080/assist-backend/doc.html`

### 3. 前端配置与启动

编辑 `RS_FRONTEND/.env`，设置后端 API 地址：

```
VITE_API_BASE_URL=/assist-backend/
```

安装依赖并启动开发服务器：

```bash
cd RS_FRONTEND
npm install
npm run dev
```

前端默认访问地址：`http://localhost:8888`

生产构建：

```bash
npm run build      # 产物输出至 dist/
npm run preview    # 本地预览构建产物
```

---

## Docker 部署

项目根目录提供 `Dockerfile`（基于 `node:20`），用于构建前端镜像：

```bash
docker build -t rs-frontend .
docker run -p 8888:8888 rs-frontend
```

> 后端建议另行打包为 Spring Boot 可执行 JAR 并容器化部署（可参考 Dockerfile 中注释的 `amazoncorretto:17` 模板）。

---

## 常用脚本

### 后端
| 命令 | 说明 |
| --- | --- |
| `mvn clean package` | 编译打包所有模块 |
| `mvn -pl RS_web -am spring-boot:run` | 仅启动 web 模块 |

### 前端
| 命令 | 说明 |
| --- | --- |
| `npm run dev` | 启动开发服务器 |
| `npm run build` | 类型检查 + 生产构建 |
| `npm run preview` | 预览构建产物 |
| `npm run lint` | ESLint 自动修复 |

---

## 部署说明

- 前端 `vite.config.ts` 中 `base: './'`，构建产物可直接作为静态文件托管。
- 生产环境建议通过 Nginx 反向代理，将 `/assist-backend/` 转发到后端服务。
- 生产环境的数据库 / Redis / OSS 配置请使用独立的 `application-prod.yml`，并通过 `spring.profiles.active` 激活。

---

## 许可证

本项目仅供学习与交流使用。
