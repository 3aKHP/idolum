---
status: accepted
---

# 品牌统一为 Idolum；eidolon 系标识符冻结到重写启动

命名决定已记录于 ADR-0029（仓库名 idolum 及备选否决），本条补上它留下的两件未决事项。

- **品牌统一为 Idolum**：产品名、三语 README 与界面品牌在 rebrand pass（ADR-0029 的缓行清单）里从 Eidolon-SC 统一换成 Idolum。大小写区分角色：标识符一律小写 `idolum`（仓库、镜像、module path），品牌一律 `Idolum`。
- **稳定期冻结 eidolon 系标识符**：后端包名 `eidolon`、环境变量前缀 `EIDOLON_*`、compose 卷名 `eidolon-data` 在稳定期不动——cherry-pick 上游修复时冲突最小，老部署升级不需要改配置，卷名改动更是会丢数据。这些标识符是否在 Go 重写时换成 idolum 系，届时随重写的兼容契约（ADR-0029）一起另议，本条不预答。

名字的完整叙事是品牌的一部分，正本在 [`docs/brand/name.md`](../brand/name.md)，README 的词源段从它节选。

## Considered Options

- **品牌沿用 Eidolon-SC**：血缘直观，但任何 `-sc` 后缀都还在上游的命名范式内，看起来像其家族的又一个变体，与独立门户的定位相悖（ADR-0029 已否决同类）。
- **品牌另起、与 idolum 无关的词**：彻底独立，但丢掉「同一个词、下一种语言」的血统叙事——那是这个名字一半的价值。
- **品牌统一为 Idolum（本条）**：仓库与品牌同源，大小写各司其职。

## Consequences

- rebrand pass 的验收标准由此确定：三语 README 与界面里的 Eidolon-SC 字样清零，换为 Idolum；落地页的品牌元素按 DESIGN.md 另行走票，不在本条范围。
- 稳定期结束前不改包名、环境变量前缀与卷名；`eidolon-data` 卷名尤其不动。
- `docs/brand/name.md` 成为品牌故事的正本；后续改名、加副品牌（如站点叫「Idolum 283」）时修订该文档，不动本条。
- 本条不设口号、不注册商标：品牌就是名字，和它的故事。
