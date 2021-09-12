resource "aws_iam_user" "github_ci_cd" {
  name = "github-ci-cd"
}

resource "aws_iam_access_key" "github_cicd_iam_access_key" {
  user = aws_iam_user.github_ci_cd.name
}

resource "aws_ssm_parameter" "github_cicd_iam_access_id" {
  name        = "github-cicd-access-id"
  description = "The access key id for the github action aws user"
  type        = "SecureString"
  value       = aws_iam_access_key.github_cicd_iam_access_key.id
}

resource "aws_ssm_parameter" "github_cicd_iam_access_secret" {
  name        = "github-cicd-access-secret"
  description = "The access key secret for the github action aws user"
  type        = "SecureString"
  value       = aws_iam_access_key.github_cicd_iam_access_key.secret
}

resource "aws_iam_user_policy_attachment" "power_role" {
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  user       = aws_iam_user.github_ci_cd.name
}
