provider "aws" {
  region = "us-east-1"
  alias  = "edge"
}

resource "aws_cloudwatch_log_group" "directory_index" {
  provider          = "aws.edge"
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
  tags              = var.function_tags
}

resource "aws_lambda_function" "directory_index" {
  provider         = "aws.edge"
  depends_on       = [aws_cloudwatch_log_group.directory_index]
  function_name    = var.function_name
  role             = var.function_role_arn
  filename         = data.archive_file.lambda_source.output_path
  source_code_hash = data.archive_file.lambda_source.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs8.10"
  publish          = true
  memory_size      = 128
  timeout          = 3
  tags             = var.function_tags

  lifecycle {
    ignore_changes = ["filename"]
  }
}

resource "aws_lambda_permission" "allow_cloudfront" {
  provider      = "aws.edge"
  statement_id  = "AllowExecutionFromCloudFront"
  action        = "lambda:GetFunction"
  function_name = aws_lambda_function.directory_index.function_name
  principal     = "edgelambda.amazonaws.com"
}

data "archive_file" "lambda_source" {
  type        = "zip"
  source_file = "${path.module}/index.js"
  output_path = "${path.module}/index.zip"
}
