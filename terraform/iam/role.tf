resource "aws_iam_role" "demo_role" {
  name = "demo_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "demo_role"
  }
}

# Instance profiles are containers for IAM roles and are used to assign roles to instances of EC2 at instance startup.
# Since the EC2 instance is a virtualized resource, it needs temporary credentials to grant permissions, which is the instance profile.
# The instance profile can not be removed from the console. Use awscli to remove it. (aws iam delete-instance-profile --instance-profile-name demo_profile)
resource "aws_iam_instance_profile" "demo_profile" {
  name = "demo_profile"
  role = "${aws_iam_role.demo_role.name}"
}

resource "aws_iam_role_policy" "demo_policy" {
  name = "demo_policy"
  role = "${aws_iam_role.demo_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::irene-demo"]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": ["arn:aws:s3:::irene-demo/*"]
        }
    ]
}
EOF
}