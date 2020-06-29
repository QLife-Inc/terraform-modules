provider "aws" {
  region = "us-east-1"
  alias  = "edge"
}

resource "aws_cloudwatch_log_group" "directory_index" {
  provider          = "aws.edge"
  name              = "/aws/lambda/us-east-1.${var.function_name}"
  retention_in_days = 7
  tags              = var.function_tags
}

resource "aws_cloudwatch_log_group" "directory_index_default" {
  provider          = "aws.edge"
  name              = "/aws/lambda/us-east-1.${var.function_name}"
  retention_in_days = 7
  tags              = var.function_tags
}

resource "aws_lambda_function" "directory_index" {
  provider         = "aws.edge"
  depends_on       = [aws_cloudwatch_log_group.directory_index]
  function_name    = var.function_name
  role             = var.function_role_arn
  filename         = data.archive_file.lambda_source.output_path
  source_code_hash = md5(file("${path.module}/index.js"))
  handler          = "index.handler"
  runtime          = "nodejs10.x"
  publish          = true
  memory_size      = 128
  timeout          = 3
  tags             = var.function_tags
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
  output_path = "${path.root}/directory_index.zip"
}
