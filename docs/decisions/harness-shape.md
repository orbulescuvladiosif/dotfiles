# Harness shape

**2026-06-15**

Original design: `agents/` directory of focused executors, reviewer agent for drift defense, subagent delegation for review and exploration.

Ships skills only. `AGENTS.md` carries operating rules; each skill is a complete workflow executor. No separate agent entities — added structure without payoff at this scale.

Subagent delegation dropped for the same reason. Cold-start cost too high for a personal harness. Replacement: small batches, compacting, claude-mem handoffs, `review-this` in self/local/PR modes. User can still invoke subagents explicitly when worth the cost.
