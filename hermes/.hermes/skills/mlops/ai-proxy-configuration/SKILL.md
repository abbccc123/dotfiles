---
name: ai-proxy-configuration
description: "Use when configuring proxies for AI tools to bypass GFW."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [proxy, gfw, ollama, vllm, networking, ai-infrastructure]
---

# AI Proxy Configuration

Managing network access for AI tools is complex because they often mix local inference with remote registry/API calls. This skill provides a framework for diagnosing and fixing connectivity issues in restricted network environments.

## Core Concepts: The AI Traffic Matrix

Before applying a fix, identify which traffic path is being blocked:

| Traffic Type | Path | GFW/Network Risk | Solution |
| :--- | :--- | :--- | :--- |
| **Local Inference** | Local App $\rightarrow$ `localhost:11434` | $\text{None}$ | No action needed. |
| **Model Pulling** | Local App $\rightarrow$ `registry.ollama.ai` | $\text{High}$ (DNS/IP block) | System-level or Process-level Proxy. |
| **Cloud Models** | Local App $\rightarrow$ `ollama.com` (via `:cloud`) | $\text{High}$ (DPI/Reset) | Encrypted Tunnel or Robust Proxy. |
| **Remote API** | Local App $\rightarrow$ `api.openai.com` etc. | $\text{Critical}$ (Reset/Block) | VPN, SSH Tunnel, or Proxy. |

## Workflow: Fixing Connectivity

### 1. Diagnosis
Check if the failure is a DNS issue or a TCP block:
- **DNS Check**: `nslookup registry.ollama.ai` or `dig`.
- **Connectivity Check**: `curl -v https://ollama.com`
- **Log Inspection**: Check `journalctl -u ollama` for connection timeouts.

### 2. Applying Proxies (The Right Way)

#### A. Shell-level (Temporary/CLI)
For one-off commands like `ollama pull`:
```bash
export HTTPS_PROXY=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890
ollama pull llama3
```

#### B. Systemd-level (Permanent for Daemons)
Since Ollama and vLLM usually run as background services, shell exports are ignored. You must edit the service definition:
1. `sudo systemctl edit ollama.service`
2. Add the following block:
   ```ini
   [Service]
   Environment="HTTP_PROXY=http://127.0.0.1:7890"
   Environment="HTTPS_PROXY=http://127.0.0.1:7890"
   ```
3. Save and exit.
4. `sudo systemctl daemon-reload`
5. `sudo systemctl restart ollama`

#### C. SSH Tunneling (For Remote AI Servers)
To access a remote Ollama API without exposing the port to the public internet (and avoiding GFW resets):
```bash
ssh -L 11434:localhost:11434 user@remote-vps-ip
```
Now you can access the remote server at `http://localhost:11434`.

## Pitfalls & Warnings

- **The `:cloud` Trap**: In newer versions of Ollama, models with the `:cloud` suffix (e.g., `qwen3:cloud`) do NOT run locally. They route to `ollama.com`. If your proxy is not configured for the daemon, these models will fail while local ones work.
- **Public Port Exposure**: Never expose port 11434 to the open internet. It is not designed for public auth and is a prime target for DPI-based connection resets by GFW.
- **Proxy Loop**: Ensure your proxy address is not being routed back through the same proxy, creating an infinite loop.
- **DNS Leak**: Even with a proxy, DNS requests might leak. Use `systemd-resolved` or a DNS-over-HTTPS (DoH) provider if `nslookup` fails.
