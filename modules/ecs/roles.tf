data "aws_iam_policy_document" "ecs_task-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "ecsTaskExecution_role" {
  name               = "ecsTaskExecution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task-assume-role-policy.json
}
resource "aws_iam_role_policy" "ecsTaskExecution_policy" {
  name = "ecsTaskExecPolicy"
  role = aws_iam_role.ecsTaskExecution_role.id

  policy = file("policies/ecsTaskExecutionPolicy.json")
}


data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsinstance_role" {
  name               = "ecsinstance_role"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}
resource "aws_iam_role_policy" "ecspolicy" {
  name = "ecspolicy"
  role = aws_iam_role.ecsinstance_role.id


  policy = file("policies/ecsInstancePolicy.json")
}

  resource "aws_iam_instance_profile" "ecs_role1" {
  name = "ecs_role1"
  role = aws_iam_role.ecsinstance_role.name
}

