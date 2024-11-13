resource "aws_sqs_queue" "terraform_queue" {
    name                      = "students"
    delay_seconds             = 90
    max_message_size          = 2048
    message_retention_seconds = 86400
    receive_wait_time_seconds = 10

    # redrive_policy = jsondecode({
    #     deadLetterTargetArn = aws_sqs_queue.queue_deadletter.arn
    #     maxReceiveCount     = 4
    # })

    tags = {
        Environment = "Production"
    }
}

resource "aws_iam_policy" "keda_sqs" {
    name = "keda-sqs"
    description = "KEDA Policy"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sqs:GetQueueAttributes"
                Effect = "Allow"
                Resource = aws_sqs_queue.terraform_queue.arn
            }
        ]
    })
}
