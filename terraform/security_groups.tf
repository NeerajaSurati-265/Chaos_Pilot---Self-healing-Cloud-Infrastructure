resource "aws_security_group" "ecs" {
  name        = "chaos-pilot-ecs-sg"
  description = "Security group for Chaos-Pilot ECS tasks"
  vpc_id      = aws_vpc.chaos_pilot.id

  ingress {
    description     = "Allow HTTP traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "chaos-pilot-ecs-sg"
  }
}

resource "aws_security_group" "nat" {
  name        = "chaos-pilot-nat-sg"
  description = "Security group for Chaos-Pilot NAT instance"
  vpc_id      = aws_vpc.chaos_pilot.id

  ingress {
    description     = "Allow traffic from ECS tasks"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    description = "Allow outbound internet traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "chaos-pilot-nat-sg"
  }
}

resource "aws_security_group" "alb" {
  name        = "chaos-pilot-alb-sg"
  description = "Security group for Chaos-Pilot ALB"
  vpc_id      = aws_vpc.chaos_pilot.id

  ingress {
    description = "Allow HTTP traffic from the Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "chaos-pilot-alb-sg"
  }
}