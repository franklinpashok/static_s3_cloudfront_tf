###########
# IAM ROLE & inline Policy
###########
resource "aws_iam_role" "form_submit_test" {
  name        = "form-submission-role"
  description = "Role required by lambda function to trigger email using ses"

  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json

  inline_policy {
    name = "form-submission-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["ses:SendEmail"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

###########
# Lambda
###########

data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "${path.module}/./modules/form_submission/lambda_function.py" 
  output_path = "pythonfunction.zip"
}


resource "aws_lambda_function" "form_submit_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "pythonfunction.zip"
  function_name = "form_submit_lambda_function"
  role          = aws_iam_role.form_submit_test.arn
  handler       = "lambda_function.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  architectures = ["x86_64"]
  runtime = "python3.9"

}

###########
# API gateway
###########
