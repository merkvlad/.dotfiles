---
name: opencode-claude-handoff-pipeline
description: "Vladimir's plan to hybridize Claude Code + opencode via file-based handoff to save on daily/weekly usage limits"
metadata: 
  node_type: memory
  type: project
  originSessionId: f813270a-6986-4d2a-bce4-0e164aa318f9
---

Vladimir планирует гибридный workflow Claude Code + opencode для экономии
usage-лимитов (дневных и недельных, не долларовой стоимости). Рабочая идея:
tmux с двумя панелями — opencode выполняет "простые", но объёмные по числу
tool-calls agentic-задачи, пишет результат в промежуточный файл; Claude
Code читает этот файл и продолжает (синтез, анализ, финальный отчёт).
Пока не решено, будет ли handoff ручным (сам копирует/триггерит) или
скриптованным (sentinel-файл + автозапуск).

Ближайший повод — курс "AI in Pentest", Homework 2 (заметка в Obsidian:
`Work/AI_in_Pentest/Lecture_2/Homework 2.md`): разведка на живой bug
bounty программе Standoff 365 (bugbounty.standoff365.com), не локальный
стенд. Реальные ограничения: read-only-first, rate-limit 5 req/s (nuclei
`-rl 3`), никаких intrusive templates, обход блокировок запрещён, реальный
баг не обязателен — сдаются 5-10 гипотез + план безопасной проверки в
жёстко заданном формате отчёта. Vladimir решил делать саму Homework 2
только с Claude (не гибридно) — не из-за нехватки возможностей у opencode,
а из-за находок в `Lecture_1/homework/домашнее_задание_agent_harness.md`:
там уже сравнивал Claude Code vs OpenCode+DeepSeek V4 Flash на смежной
задаче триажа с prompt injection, и без явных строгих правил у OpenCode
был непоследовательный стандарт доказательности (одна находка "confirmed"
без оснований, другие — нет) — риск для грейдинга финального отчёта.

Ожидается, что похожие задачи (гибридный pipeline) будут повторяться в
дальнейшей работе: сканирование уязвимостей Docker/Kubernetes, bug
hunting, а также обычный поиск/парсинг данных с сайтов.

Концептуальная заметка (архитектура, детальный алгоритм разведки,
слои ограничения агента, безопасное делегирование парсинг-задач)
зафиксирована в Obsidian: `Work/AI_in_Pentest/OpenCode + Claude —
гибридная разведка (концепция).md`.

**Why:** не хочет упираться в дневные/недельные лимиты Claude Code —
делегирует объёмную по tool-calls "простую" работу на бесплатный opencode,
Claude оставляет для синтеза, ревью находок и финальной документации.
Также связано с [[opencode-agents-md-symlink]] — общий rules-файл уже
синхронизирован между Claude Code и opencode, и с
[[opencode-playwright-mcp-incident]] — реальный случай, когда одних
текстовых правил в AGENTS.md оказалось недостаточно.

**How to apply:** при обсуждении подобных задач — предлагать file-based
handoff со структурированным промежуточным форматом (JSON), атомарной
записью (tmp+rename) и явным сигналом завершения (sentinel-файл), а не
полагаться на угадывание готовности по времени. Помнить, что Claude Code
не может сам проактивно спавнить или ждать сторонние CLI-сессии (opencode)
без explicit-скрипта — это вне Agent-тула. Для задач с реальными
последствиями (код-выполнение, сеть за пределы scope, запись файлов) —
всегда рекомендовать deny-by-default permission-слой в opencode.jsonc
поверх текстовых правил, не вместо них. Перед тем как проектировать
пайплайн для конкретного задания — сверяться с реальным текстом задания
в Obsidian-вейлте (`Work/AI_in_Pentest/`), а не с общими предположениями.
