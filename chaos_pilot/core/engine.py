from chaos_pilot.experiments.task_failure import TaskFailureExperiment


class ChaosEngine:

    def __init__(self):
        self.task_failure = TaskFailureExperiment(
            cluster_name="chaos-pilot-cluster"
        )

    def get_status(self):
        return {
            "platform": "Chaos-Pilot",
            "status": "ready",
            "message": "Chaos engine is ready"
        }

    def run_task_failure(self, task_id: str):
        return self.task_failure.stop_task(task_id)