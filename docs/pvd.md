# AI Workflow Config — Product Vision Document

## What it is

dotfiles repo — consistent AI behavior across machines and tools (Claude Code, Cursor). One `ai/` directory in Git, installed on demand. No frameworks, no third-party lock-in. Developer owns it entirely.

## The interface

AGENTS.md first. Then `conventions/` (standards) and `skills/` (workflows). Skills teach and act — no separate `agents/` directory.

## Core mechanic

Corrections → conventions. Repeated workflows → skills. Sparse first, dense over time.

## AI drift

Written rules aren't enough.

- Conventions — standard
- Codebase — passive pattern enforcement
- Gates — checkpoint violations
- Review — `review-this` catches slips
- caveman + claude-mem — session reinforcement

Good faith at the bottom; tooling at the top.

## Setup

Remote installer; warns if caveman or claude-mem missing; syncs harness into place.

## Principles

- Small primitives, composed — not fat parts
- Portable — one repo, one install
- Owned — no required third-party services
