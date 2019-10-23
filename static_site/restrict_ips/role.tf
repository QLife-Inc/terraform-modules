resource "aws_iam_role" "lambda_edge" {
  count                 = length(var.allowed_ip_addresses) > 0 ? 1 : 0
  name                  = var.function_role_name
  path                  = "/service-role/"
  assume_role_policy    = data.aws_iam_policy_document.lambda_edge.json
  tags                  = local.function_role_tags
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "basic" {
  count      = length(var.allowed_ip_addresses) > 0 ? 1 : 0
  role       = aws_iam_role.lambda_edge[count.index].name
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
