from fastapi import FastAPI
from chaos_pilot.core.engine import ChaosEngine

app = FastAPI(
    title="Chaos-Pilot",
    description="Cloud resilience and automated remediation platform",
    version="0.1.0"
)

engine = ChaosEngine()


@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "chaos-pilot"
    }


@app.get("/status")
def status():
    return engine.get_status()

@app.post("/experiments/task-failure")
def task_failure(task_id: str):
    return engine.run_task_failure(task_id)