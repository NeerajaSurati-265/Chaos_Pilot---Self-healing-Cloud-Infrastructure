data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "nat" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.nat.id
  ]

  # Required because this EC2 instance forwards
  # traffic that is not directly addressed to it.
  source_dest_check = false

  # Configure the instance to perform NAT.
  user_data = <<-EOF
    #!/bin/bash
    set -eux

    # Enable IPv4 forwarding
    sysctl -w net.ipv4.ip_forward=1

    cat > /etc/sysctl.d/99-chaos-pilot-nat.conf <<'SYSCTL'
    net.ipv4.ip_forward = 1
    SYSCTL

    sysctl --system

    # Install nftables
    dnf install -y nftables

    # Find the internet-facing network interface
    OUT_IF=$(ip route show default | awk '/default/ {print $5; exit}')

    # Configure NAT masquerading
    cat > /etc/nftables/main.nft <<NFT
    #!/usr/sbin/nft -f

    flush ruleset

    table ip nat {
      chain postrouting {
        type nat hook postrouting priority 100;
        policy accept;

        ip saddr 10.0.0.0/16 oifname "$OUT_IF" masquerade
      }
    }
    NFT

    # Enable and start nftables
    systemctl enable --now nftables

    # Apply NAT rules
    nft -f /etc/nftables/main.nft
  EOF

  tags = {
    Name = "chaos-pilot-nat"
  }
}