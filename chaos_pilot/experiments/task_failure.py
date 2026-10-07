import boto3


class TaskFailureExperiment:

    def __init__(self, cluster_name: str):
        self.cluster_name = cluster_name
        self.ecs = boto3.client("ecs")

    def stop_task(self, task_id: str):
        response = self.ecs.stop_task(
            cluster=self.cluster_name,
            task=task_id,
            reason="Chaos-Pilot task failure experiment"
        )

        return {
            "task_id": task_id,
            "status": response["task"]["lastStatus"],
            "reason": response["task"].get("stoppedReason")
        }