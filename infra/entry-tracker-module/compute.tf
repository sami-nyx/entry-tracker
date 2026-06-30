#=============================================ec2 instance=============================================
resource "aws_instance" "ec2_instance" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.instance_sg.id]
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    associate_public_ip_address = true
    tags = {
        Name = var.ec2_instance_name,
        Environment = "staging",
        Project = "entry-tracker"
    }
    user_data = file("${path.module}/userdata.sh")
}