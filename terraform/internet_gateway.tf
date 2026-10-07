resource "aws_internet_gateway" "chaos_pilot" {
  vpc_id = aws_vpc.chaos_pilot.id

  tags = {
    Name = "chaos-pilot-igw"
  }
}