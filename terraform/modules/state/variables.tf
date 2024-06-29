variable "s3_bucket" {
  description = "The S3 bucket in which the state is stored."
  sensitive   = false
  type        = string
}

variable "dynamodb_table" {
  description = "The DynamoDB table used to obtain a lock on the state."
  sensitive   = false
  type        = string
}
