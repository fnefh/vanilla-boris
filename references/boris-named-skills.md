# Skills and agents Boris named on his site (attribution)

Source: howborisusesclaudecode.com.

Boris references many skill and agent names by hand throughout the site
without publishing the contents. Below is the inventory of those names,
paired with whether this plugin ships an equivalent (under a possibly
different name) or leaves it as user-territory.

## Skills Boris named

| Name | Shipped here? | Notes |
|---|---|---|
| `signup-driver` | ❌ | Product-verification skill specific to a signup flow. User-territory. |
| `checkout` | ❌ | Same — domain skill. |
| `new-app` | ❌ | Scaffolding skill, framework-specific. |
| `migration` | ❌ | Domain-specific data/schema migrations. |
| `adversarial` | ✅ (≈) | Our `challenge-me` skill is the adversarial-review pattern. |
| `hypothesis` | ❌ | Hypothesis-testing pattern. Could be a future addition. |
| `babysit-pr` | ✅ | Our `commands/babysit.md`. |
| `oncall` | ❌ | Incident-runbook skill (type 8 of 9). |
| `log-correlator` | ❌ | Data/analysis skill. |
| `orphans` | ❌ | Likely a code-quality skill (find orphan files/exports). |
| `cost-investigation` | ❌ | Data/analysis skill for cloud cost queries. |
| `funnel-query` | ❌ | Analytics skill. |
| `grafana` | ❌ | Library-reference skill for Grafana queries. |
| `platform-cli` | ❌ | Library-reference skill for an internal CLI. |
| `billing-lib` | ❌ | Library-reference skill for billing internals. |
| `spaced-repetition` | ❌ | Learning skill — interesting; could be a future reference. |
| `dbt-model-agents` | ❌ | dbt model writing/review agents. |

## Agents Boris named

| Name | Shipped here? | Notes |
|---|---|---|
| `code-simplifier` | ✅ (`simplifier`) | We renamed slightly; pattern matches. |
| `verify-app` | ✅ (`verifier`) | Same. |
| `build-validator` | ❌ | Build-step validator. Could pair with our `verifier`. |
| `code-architect` | ❌ | Architecture-review agent. |
| `oncall-guide` | ❌ | Incident-response agent. |
| `sentry-errors` | ❌ | Sentry-MCP-driven error triage. |
| `worktree-worker` | ❌ | Worktree orchestration agent. |
| `ReadOnly` | ❌ | Restricted-tools agent at autonomy ladder rung 1. |
| `analysis worktree` | ❌ | Worktree restricted to logs + BigQuery only. |

## Why this list exists

Boris's site is a high-quality habit set. The temptation when reading it
is to ship fifteen different agent files all named the way Boris named
his — which would amount to *implying* he authored them.

Instead this plugin ships only what is genuinely reconstructable from
public phrasing (`/babysit`, `/go`, `/post-merge-sweeper`, `/pr-pruner`,
`/slack-feedback`, `/verify`, `/full-brief`, `/challenge-me`) and
attribution-tracks the rest. If you want one of the unshipped items,
write it yourself under the relevant skill type — `skills/skill-author`
walks through Thariq's nine rules.
