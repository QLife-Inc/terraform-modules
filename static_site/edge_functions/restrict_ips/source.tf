data "template_file" "lambda_source" {
  template = file("${path.module}/index.js")
  vars = {
    allowed_ip_addresses = join(",", var.allowed_ip_addresses)
  }
}

data "archive_file" "lambda_source" {
  type        = "zip"
  output_path = "${path.root}/restrict_ips.zip"

  source {
    content  = data.template_file.lambda_source.rendered
    filename = "index.js"
  }
}
