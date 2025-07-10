output "neo_cloudwatch_policy_arn" {
    value = one(concat(
        aws_iam_user_policy_attachment.neo-cloudwatch-full-access.policy_arn,
        aws_iam_user_policy_attachment.neo-cloudwatch-read-only.policy_arn
    ))
}