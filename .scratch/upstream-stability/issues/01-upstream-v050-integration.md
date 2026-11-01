# 01: Integrate upstream v0.5.0 while preserving the independent Idolum line

Status: done

Implement [the spec](../spec.md). The user's full-feature selection supersedes the initially proposed performance-only batch. Root performs integration. The user authorized committing and pushing the integration branch on 2026-11-01; release and deployment remain outside this task.

## Acceptance

- [x] All upstream v0.5.0 functionality, assets, tests and documentation are integrated.
- [x] Idolum repository links, registry image names, existing independent ADRs and identifier compatibility are retained; fork-showcase automation remains removed.
- [x] Dependency conflicts preserve newer local versions and lockfiles install reproducibly.
- [x] Imported ADRs have unique identifiers and correct cross-references.
- [x] HTTP and SQLite snapshots match the integrated implementation; baseline provenance identifies the upstream import without rewriting the historical oracle.
- [x] Affected checks, frontend build, shell/scratch checks and isolated browser smoke acceptance pass, or concrete limitations are recorded.
- [x] Review findings are addressed and implementation/validation notes are recorded.

## Comments

### Scope decision (2026-11-01)

The user explicitly selected “尽量追上上游全部功能”. A full merge is preferable to hundreds of cherry-picks. No first-batch patches were applied before the selection.

### 实现说明（票 01）

- 完整合入 upstream/main `f6cee74b`（v0.5.0）的 293 个提交对应的内容，采用保留双亲历史的 merge；集成分支 `maintenance/upstream-v0.5.0`。用户于 2026-11-01 明确允许推送，随后提交并发布该集成分支。
- 六处合并冲突已解决。保留本线较新的 FastAPI、uv-build、Ruff、React 等版本；带入 holidays、pytest-xdist 以及上游 shadcn/zod 等更新。`uv sync --locked`、`npm ci --ignore-scripts --no-audit --no-fund` 成功。
- 运行时代码与上游的差异仅为 ADR 引用重编号、仓库链接和文件尾空白清理；产品功能、素材和测试全部保留。新增 ADR 的 0029–0032 顺延为 0032–0035，并同步源码、测试、评测与历史规格中的引用；本线已有 ADR 正文不改。上游展示登记工作流仍删除，镜像继续发布到 `ghcr.io/3akhp/idolum-*`。
- 部署指引和中文 README 的新增部署 prompt 指向 Idolum。实现指引明确 ADR-0029 的授权要求，覆盖继承的自动提交/推送步骤。
- HTTP/SQLite 契约在独立临时数据库与假外部服务上重新导出：104 个路径、130 个操作、70 张表；baseline 保留历史 oracle，新增本轮快照基点说明。数据包格式随上游为 5。
- 修复一处移植验收中发现的测试环境依赖：本机小写 `http_proxy` 会覆盖测试设置的大写变量。只去掉继承的小写变量时原测试通过，说明产品代理行为无回归；现有测试同时设置大小写六个变量，隔离宿主环境，无新增产品行为。

### 验证

- `sh scripts/affected-tests.sh 58d53286`：Ruff、Pyright、前端类型检查通过；67 个前端测试文件、1216 个用例通过。后端 2196 个受影响用例首轮 2195 通过、上述代理环境测试 1 失败；隔离环境复现和修复后 `tests/test_proxy.py` 的 33 个用例全部通过，包括原失败项。未额外重跑后端全量套件。
- `npm run build` 通过；shadcn 纪律、scratch 检查、ShellCheck、`git diff --check`、ADR 编号唯一性及仓库/镜像设置检查通过。
- Playwright 在本地生产构建版上，使用专用临时库和假 LLM/语音/天气/价格服务验收：五组 API；桌面对话列表、玩法、日历/日程、周期、朋友圈、设置、后台配置及一次真实页面文字回合；手机对话列表、玩法、日历、周期、朋友圈、设置均无横向溢出。补验朗读菜单、桌面酒吧和手机酒吧横屏提示。无浏览器未捕获异常。
- 规范审查发现遗漏的 ADR 引用，已全部修正；规格审查确认上游功能完整，最终两轴无未解决发现。
- 日志与截图在 `/tmp/idolum-upstream-*`；没有改 `.env`、没有连接部署库、没有真实付费 API 调用。验收用服务结束后停止。

### 首次启动（不属于本次推送）

用户确认项目还没有启动过，没有旧部署数据需要迁移。首次启动按当前代码建库，数据包格式为 5；朋友圈和信默认关闭，和风天气、配乐及真实语音按需配置。本次只提交、推送代码并检查 CI，不发布版本或部署服务。
