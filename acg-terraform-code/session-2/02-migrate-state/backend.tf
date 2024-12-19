terraform {
  backend "s3" {
    bucket = "terraform-backend-terraformbackends3bucket-ahqbpgccbejl"
    key = "web-server"
    region = "us-east-1"
    dynamodb_table = "terraform-backend-TerraformBackendDynamoDBTable-QV3P88IQDKDD"
  }
}