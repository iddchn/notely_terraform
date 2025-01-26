resource "kubernetes_manifest" "ebs_storage_class" {
  manifest = yamldecode(file("${path.module}/manifests/ebs-storage-class.yaml"))
}

#install argocd
resource "helm_release" "argocd" {
  depends_on = [kubernetes_manifest.ebs_storage_class]
  name  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  create_namespace = true
  namespace = "argocd"
  chart = "argo-cd"
  version = "7.7.16"
}

resource "helm_release" "elasticsearch" {
  depends_on = [kubernetes_manifest.ebs_storage_class]
  name  = "elasticsearch"
  create_namespace = true
  namespace = "logging"
  repository = "https://helm.elastic.co"
  chart = "elasticsearch"
  version = "8.5.1"
  values = [
    file("${path.module}/values/elasticsearch-values.yaml")
  ]
}

resource "helm_release" "fluent-bit" {
  depends_on = [helm_release.elasticsearch]
  name  = "fluent-bit"
  namespace = helm_release.elasticsearch.namespace
  repository = "https://fluent.github.io/helm-charts"
  chart = "fluent-bit"
  version = "0.48.4"
  values = [
    file("${path.module}/values/fluent-bit-values.yaml")
  ]
}

resource "helm_release" "kibana" {
  depends_on = [helm_release.fluent-bit]
  name  = "kibana"
  namespace = helm_release.elasticsearch.namespace
  repository = "https://helm.elastic.co"
  chart = "kibana"
  version = "8.5.1"
  values = [
    file("${path.module}/values/kibana-values.yaml")
  ]
}

