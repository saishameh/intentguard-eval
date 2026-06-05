# ── IntentGuard Green Agent ───────────────────────────────────────────────────
# Containerises the evaluator / attack runner as an AgentBeats Green Agent.
# Build:  docker build -t intentguard-green .
# Run:    docker run -p 8001:8001 intentguard-green

FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY green_agent.py ./green_agent.py
COPY attacks.json   ./attacks.json

ENV PORT=8001
EXPOSE 8001

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8001/health || exit 1

CMD ["python", "-m", "uvicorn", "green_agent:app", "--host", "0.0.0.0", "--port", "8001"]