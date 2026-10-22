---
status: accepted
---

# 自 f2a8978 起从上游独立维护；后端稳定后以 Go 重写，兼容契约先行；开发习惯按本仓库自己的约定对齐

本条是本仓库自己的第一条 ADR。0001–0028 继承自 Sallyn0225/eidolon-sc，编号沿用、决策链不断；本条记录分叉本身与随之拍板的三件事。讨论与定案日期：2026-10-23。

### 一、自立门户，不用 GitHub fork

新建自己的仓库推送，完整保留 git 历史、`LICENSE`（AGPL-3.0-or-later）、`LICENSING.md`（AGPL 第 7 节附加许可）与 `frontend/public/vendor/spine-3.6/`（原样，校验和见其 README）。仓库名定为 **idolum**——eidōlon（εἴδωλον）进入拉丁语的借形，与上游之名是同一个词的下一种语言；取单数（体验的单位是与一位的对话，且「一位是 idolum，全部 29 位是 idola」的双关只在单数下成立），不加 `-sc` 或 `-283` 后缀——后缀用于消歧，而本名近乎无重名；作品归属写进仓库 description、topics 与 README，不进标识符。分叉点是 `f2a897825a27b03a6371d44dad07de0faabe94e2`（2026-10-22 的上游 main）。上游留作只读 remote，仅供偶尔 cherry-pick 修复，不承担同步义务。衍生作品（含后端重写若为翻译式移植）同样 AGPL，本仓库不依赖净室重写的许可灰区。

### 二、后端稳定后以 Go 重写，实时语音保留

先把继承的 Python 后端原样运行到一切稳定，重写放在稳定之后。目标语言 Go；WebRTC 用 pion/webrtc；RTVI 服务端自行实现（前端 `@pipecat-ai/client-js` 与 `docs/agents/local-acceptance.md` 的假后端是协议参考）。路线是绞杀者模式：文字 / HTTP / 引擎先换，通话管线最后替换，期间可留作 Python 小服务。重写期间以下列兼容契约为准，存入 `contracts/`：

- HTTP `/api/*` 的返回形状，以分叉点导出的 `/openapi.json` 为准；
- RTVI datachannel 消息协议；
- SQLite schema（51 张表，沿用同一库文件）；age 加密备份在 Go 侧用 FiloSottile/age 原生兼容。

行为 oracle 是继承的 1,597 个测试（挑选冻结为差分用例），方法论沿用 prts-mcp 2.x→3.x 的做法：冻结旧版为 oracle、baseline 记录逐条批准偏差。

### 三、开发习惯对齐

保留：GLOSSARY / ADR 链、`.scratch` 票制（稳定期）、`CODING_STANDARDS.md`、merge commit 不 squash。引入：commit message 统一英文（Conventional Commits）；agent 须明确指令才 commit、不主动 push（修订 `docs/agents/implementing.md` 的收尾流程）；补写 `ARCHITECTURE.md`（描述现状依赖方向，兼作重写蓝图）与 `documenting.md`（公开文档写作规范）；增加 STATUS / ROADMAP / CHANGELOG。时机：稳定期保持单 main（便于 cherry-pick 上游），GitFlow 双线在重写启动时引入。缓行：双语文档（canonical + mirror）与大文件拆分，都留给重写期。GLOSSARY 按需生长，条目带 Avoid 反义词列表；ADR 公开，草稿可先私有、接受后晋升。

## Considered Options

- **GitHub fork + Sync fork 跟随上游**：省去分家动作，但 issue tracker 默认关闭、被归入上游 fork 网络（DMCA 整网络连坐）、且与独立路线自相矛盾；git remote 本身已满足「偶尔捡上游一个修复」，fork 关系并不必要。
- **立即重写后端**：省去维护不熟悉代码的时间，但跳过「跑稳」阶段就不知道哪些功能值得留（直接决定重写范围），也没有真实数据可当验收基准。
- **重写时不保语音、砍掉通话**：工作量降一个数量级，但通话是本产品的核心体验，砍掉等于换一个产品。
- **净室重写以脱离 AGPL**：法律灰区；本仓库公开且无意闭源，AGPL 不构成实际约束，不值得为它改变重写方式。
- **命名备选**：aoide（缪斯司歌声）、simulacrum（哲学最准但 359 结果且与 SIMULACRA 游戏混淆）、imago（意象佳但被图像处理赛道占满）、fama（维吉尔流言怪物，被金融学淹没）、idola 复数（与世嘉旧作 IDOLA 相撞）；idolum 以「血统 + 14 结果的最干净命名空间 + 字面命中」胜出。

## Consequences

- 分家的第一批提交改掉上游 CI 硬编码（`ci.yml`、`release.yml`、`release_notes.py` 的 GHCR 镜像名与 dependabot 的 ignore 条目），删除 `fork-showcase.yml`。
- 稳定期对 Python 代码的任何改动必须保持 1,597 个测试全绿（CI 强制）——它既是行为基线，也是未来差分用例的来源。
- `contracts/` 建立后，重写期间的每一条行为偏差都要在 baseline 里留记录，不允许悄悄漂移。
- 换 Go 时，`store.py`、`call.py`、`activity.py`、`live_config.py`、`engine.py` 等大文件按五信号（语义内聚 / 变更原因 / 耦合与知识 / 局部推理与测试 / 变更安全）逐个重新划界；package 结构按领域分目录，不再平铺。
- 原作素材的边界沿用上游约定：剧情库、音色、立绘素材不进仓库（ADR-0003）；Spine 许可证的风险姿态随 vendor 目录一并继承（ADR-0009）。
- 自本条起，凡难以回头或将来可能重议的决定都进本目录；已接受的 ADR 不改写，只追加带日期的修订。
