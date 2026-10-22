# RTVI 消息协议（初稿笔记）

> 状态：第一遍整理，来源是 `docs/agents/local-acceptance.md` 里那个可运行的假后端和前端 `@pipecat-ai/client-js` 的行为。**全量 JSON Schema 待提取**——做 Go 通话管线时的第一个任务就是把这里升格成正式 Schema + 消息样本。

通话的前后端契约分两层：HTTP 信令 + WebRTC 数据通道（RTVI）。

## HTTP 信令

| 请求 | 方向 | 内容 |
|---|---|---|
| `POST /api/offer` | 浏览器 → 后端 | WebRTC offer（SDP）；后端回 `{sdp, type: "answer", pc_id}` |
| `PATCH /api/offer` | 浏览器 → 后端 | 补发的 ICE 候选，挂到对应 `pc_id`；后端回 `200 {}` |

## 数据通道（label `rtvi-ai`）

握手与消息（来自 local-acceptance.md 的假后端，即可运行的服务端规格）：

| 消息 | 方向 | 形状 |
|---|---|---|
| `client-ready` | 浏览器 → 后端 | `{"label":"rtvi-ai","type":"client-ready","id":<id>}` |
| `bot-ready` | 后端 → 浏览器 | `{"label":"rtvi-ai","type":"bot-ready","id":<同 id>,"data":{"version":"1.0.0"}}`——接到 `client-ready` 后立即回 |
| `server-message` | 后端 → 浏览器 | `{"label":"rtvi-ai","type":"server-message","data":<应用消息>}`；`data` 里见过的有 `ended`（她挂断、到上限）与 `done` |
| `peerLeft` | 后端 → 浏览器 | `{"type":"signalling","message":{"type":"peerLeft"}}`——挂断时由传输层发出 |

音频经 WebRTC 音轨收发（offer 里的收发器须为 `sendrecv`）。

## 权威来源（提取全量 Schema 时对照）

- 前端依赖：`frontend/node_modules/@pipecat-ai/client-js`（消息类型定义）
- 假后端参考实现：`docs/agents/local-acceptance.md`「造出后端在通话里发的消息」一节
- 服务端实现：`backend/src/eidolon/call.py` + pipecat `small-webrtc-transport`
- 协议文档：pipecat 官方文档的 RTVI 章节
