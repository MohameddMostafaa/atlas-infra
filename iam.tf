resource "aws_iam_role" "atlas_ec2" {
  name        = "AtlasEC2Role"
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

resource "aws_iam_role" "terraform_github" {
  name = "AtlasTerraformRole"

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
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:MohameddMostafaa@41244098/atlas-infra@1346806408:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "terraform_github" {
  name = "AtlasTerraformInfrastructure"
  role = aws_iam_role.terraform_github.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "EC2"
        Effect = "Allow"

        Action = [
          "ec2:Describe*",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:ModifySecurityGroupRules",
          "ec2:ModifyInstanceAttribute",
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ]

        Resource = "*"
      },
      {
        Sid    = "IAM"
        Effect = "Allow"

        Action = [
          "iam:GetRole",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:GetRolePolicy",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:UpdateRole",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy"
        ]

        Resource = [
          "arn:aws:iam::${var.aws_account_id}:role/AtlasEC2Role",
          "arn:aws:iam::${var.aws_account_id}:role/AtlasGitHubDeployRole"
        ]
      }
    ]
  })
}
