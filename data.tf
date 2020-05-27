data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["cmd-sandpit1-vpc-1"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name = "tag:Name"
    values = ["cmd-sandpit1-vpc-1-private-*"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name = "tag:Name"
    values = ["cmd-sandpit1-vpc-1-public-*"]
  }
}
