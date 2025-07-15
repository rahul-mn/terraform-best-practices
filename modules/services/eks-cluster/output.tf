output "cluster_name" {
  value = "${aws_eks_cluster.cluster.name}"
  description = "Name of the EKS Cluster"
}

output "cluster_arn" {
  value = aws_eks_cluster.cluster.arn
  description = "ARN of the EKS Cluster"
}

output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
  description = "Endpoint of the EKS Cluster"
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.cluster.certificate_authority
  description = "Certificate Authority of the EKS Cluster"
}