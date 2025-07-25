data "aws_iam_policy_document" "cluster_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cluster" {
  name = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  role = "${aws_iam_role.cluster.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
  name = "vpc-id"
  values = [data.aws_vpc.default.id]
  }
}

resource "aws_eks_cluster" "cluster" {
  name = "${var.name}"
  role_arn = "${aws_iam_role.cluster.arn}"
  version = "1.21"

  vpc_config {
    subnet_ids = data.aws_subnets.public.ids
  }

  depends_on = [ aws_iam_role_policy_attachment.AmazonEKSClusterPolicy ]
}
  
resource "aws_iam_role" "node_group" {
  name = "${var.name}-node-group"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
}

data "aws_iam_policy_document" "node_group_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = "${aws_iam_role.node_group.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = "${aws_iam_role.node_group.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = "${aws_iam_role.node_group.name}"
}

resource "aws_eks_node_group" "node_group" {
  cluster_name = "${aws_eks_cluster.cluster.name}"
  node_group_name = var.name
  node_role_arn = "${aws_iam_role.node_group.arn}"
  subnet_ids = data.aws_subnets.public.ids
  instance_types = var.instance_types

  scaling_config {
    min_size = var.min_size
    max_size = var.max_size
    desired_size = var.desired_size
  }

  depends_on = [ aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy, aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly, aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy ]
  
}