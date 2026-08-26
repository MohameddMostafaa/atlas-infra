resource "aws_iam_role" "atlas_ec2" {
  name = "AtlasEC2Role"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "atlas_ec2_ssm" {
  role       = aws_iam_role.atlas_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_role_policy" "atlas_cloudwatch_metrics" {
  name = "AtlasCloudWatchMetrics"
  role = aws_iam_role.atlas_ec2.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "PublishAtlasHealthMetric"
        Effect = "Allow"

        Action = [
          "cloudwatch:PutMetricData"
        ]

        Resource = "*"

        Condition = {
          StringEquals = {
            "cloudwatch:namespace" = "Atlas"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role" "github_deploy" {
  name = "AtlasGitHubDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:sub" = "repo:MohameddMostafaa@41244098/atlas@1327297738:ref:refs/heads/main"
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy" "github_deployment_ssm" {
  name = "AtlasDeploymentSSM"
  role = aws_iam_role.github_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "SendDeploymentCommand"
        Effect = "Allow"

        Action = "ssm:SendCommand"

        Resource = [
          "arn:aws:ec2:${var.aws_region}:${var.aws_account_id}:instance/i-043a6f6e6e04cbab3",
          "*"
        ]
      },
      {
        Sid    = "CheckDeploymentCommand"
        Effect = "Allow"

        Action = "ssm:GetCommandInvocation"

        Resource = "*"
      }
    ]
  })
}
