# Recommended MCPs

Source: howborisusesclaudecode.com §"Tool Integrations & MCPs".

Boris's daily MCP set:

| MCP | What | Verify-loop fit |
|---|---|---|
| **Slack** | Search and post messages. Stub URL on the site: `https://slack.mcp.anthropic.com/mcp` | Used by `/slack-feedback`-style commands when the Slack MCP is installed (else fall back to `feedback.md`). |
| **BigQuery (`bq` CLI)** | Query analytics directly. Boris: "haven't written SQL in 6+ months." | Verification path for data work. |
| **Sentry** | Fetch error logs. | Verification path for incident response. |
| **Chrome extension** | Browser testing — Claude opens a real browser, iterates on UI. | The verification path for frontend work. |
| **Desktop app web servers** | Auto-start/test web servers from inside the app. | Verification path for full-stack work. |
| **iMessage plugin** | Text Claude from Messages. | Mobile/async, not verification. |

Install patterns vary; consult each MCP's docs. **This plugin does not
install MCPs.** Run `/mcp-audit` after adding any of them.
