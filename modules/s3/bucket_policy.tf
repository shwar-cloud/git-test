<<<<<<< HEAD
# Source Bucket Policy
=======
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
resource "aws_s3_bucket_policy" "sclr_source_kmspolicy" {
  bucket = aws_s3_bucket.sclr_source.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [      
  {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.sclr_replication_role.arn
        }
        Action = [
          "s3:ListBucket",
          "s3:GetReplicationConfiguration",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectRetention",
          "s3:GetObjectLegalHold"
        ]
        Resource = "${aws_s3_bucket.sclr_source.arn}/*"
      },
  #uploads need to be encrypted
      {
<<<<<<< HEAD
        Effect    = "Allow"
        Principal = { AWS = aws_iam_role.sclr_replication_role.arn }
        Action    = ["s3:ListBucket","s3:GetReplicationConfiguration"]
        Resource  = aws_s3_bucket.sclr_source.arn
      },
      {
        Effect    = "Allow"
        Principal = { AWS = aws_iam_role.sclr_replication_role.arn }
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectRetention",
          "s3:GetObjectLegalHold"
        ]
        Resource = "${aws_s3_bucket.sclr_source.arn}/*"
      },
      {
        Sid       = "DenyUnEncryptedUploads"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.sclr_source.arn}/*"
        Condition = { StringNotEquals = { "s3:x-amz-server-side-encryption" = "aws:kms" } }
=======
        Sid = "DenyUnEncryptedUploads"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.sclr_source.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = "aws:kms"
          }
        }
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
      }
    ]
  })
}
<<<<<<< HEAD

# Destination Bucket Policy
=======
 #Destination
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
resource "aws_s3_bucket_policy" "sclr_destination_kmspolicy" {
  provider = aws.dr
  bucket   = aws_s3_bucket.sclr_destination.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
<<<<<<< HEAD
        Effect    = "Allow"
        Principal = { AWS = aws_iam_role.sclr_replication_role.arn }
        Action = [
          "s3:ReplicateObject",
=======
        Effect = "Allow"
        Principal = { 
        AWS =aws_iam_role.sclr_replication_role.arn
         }
       Action = [
          "s3:ReplicateObject", 
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:GetObjectVersionTagging",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]
        Resource = "${aws_s3_bucket.sclr_destination.arn}/*"
<<<<<<< HEAD
      },
      {
        Effect    = "Allow"
        Principal = { AWS = aws_iam_role.sclr_replication_role.arn }
        Action    = ["s3:ListBucket"]
        Resource  = aws_s3_bucket.sclr_destination.arn
      }
=======
       }
>>>>>>> 7a2216ea509432eef42f2c9204d95f6393d90765
    ]
  })
}
