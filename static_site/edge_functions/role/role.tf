resource "aws_iam_role" "lambda_edge" {
  name                  = var.role_name
  path                  = "/service-role/"
  assume_role_policy    = data.aws_iam_policy_document.lambda_edge.json
  tags                  = var.role_tags
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda_edge.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_edge" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}
