# contracts/

本目录是 idolum 的**兼容契约**：机器可读的「系统对外表现为怎样」的快照（ADR-0029）。它同时服务两件事：

- **现在**：任何 PR 的 diff 里出现本目录的文件，就意味着这次改动动了接口面或表结构——意外的破坏性变更在 review 里藏不住；
- **重写期**：Go 后端对着这些契约做差分测试，`baseline.json` 记录每一处有意的偏差（编号 + 理由），漂移必须留下账。

## 文件

| 文件 | 内容 | 怎么再生成 |
|---|---|---|
| `openapi.json` | 全部 HTTP 端点的契约（FastAPI 自动生成）。标题仍是 Eidolon-SC——标识符冻结期内预期如此（ADR-0031） | `curl -s http://127.0.0.1:8000/openapi.json > contracts/openapi.json` |
| `schema.sql` | SQLite 全部 51 张表（新库启动即建的 46 张 + 剧情库懒建的 5 张，见文件头注释） | 见下方「补齐懒建表」 |
| `rtvi/` | 通话数据通道的消息协议笔记（初稿，全量 Schema 待提取） | — |
| `baseline.json` | 偏差账本：Go 实现每一处不等于 oracle 的地方，编号记录 | 手工维护 |

## 再生成步骤

后端启动时会真连对话模型做流式+工具调用检查（`llm/providers.py`），没有真 key 时用一个一次性的本地 mock 即可：

```sh
# 1) 起一个 OpenAI 兼容 mock（或用真实的 .env）
python3 /tmp/idolum-llm-mock.py &          # 见下：mock 怎么写
# 2) .env 里 CHAT_LLM_BASE_URL=http://127.0.0.1:8099/v1，然后：
cd backend && uv run --env-file=../.env eidolon serve &
curl -s http://127.0.0.1:8000/openapi.json > ../contracts/openapi.json
# 3) 新库 + 补齐剧情库懒建表，再导出 schema
uv run python -c "
import sqlite3
from eidolon import corpus, embedded_texts
db = sqlite3.connect('data/eidolon.db')
corpus._open(db, 'none'); embedded_texts._create(db); db.commit()"
python3 -c "import sqlite3, pathlib; db = sqlite3.connect('backend/data/eidolon.db'); pathlib.Path('contracts/schema.sql').write_text(';\n'.join(r[0] for r in db.execute(\"SELECT sql FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name\")) + ';\n')"
```

mock 的要点：`POST {base_url}/chat/completions` 回标准 SSE（role delta → content delta → finish_reason=stop → `data: [DONE]`），工具调用可回可不回。

## 规矩

- 改了对外行为的 PR **同 PR 更新本目录**——契约 diff 就是那次改动的接口面 review 材料；
- 重写期间 Go 实现的每一处有意偏差进 `baseline.json`，禁止悄悄漂移；
- 本目录只记「对外表现」，不记内部实现——模块重排、内部重构不产生契约 diff，这正是它该有的样子。
